import 'dart:async';
import 'dart:convert';
import 'package:boardwalk/auth/auth_credentials.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart' as auth;
import 'package:boardwalk/main.dart';

enum AuthFlowStatus { login, signUp, verification, session }

class AuthState {
  final AuthFlowStatus authFlowStatus;

  AuthState({required this.authFlowStatus});
}

class CognitoService {
  userExist(String email) {
    return Amplify.Auth.signIn(username: email, password: '');
  }
}

class AuthService {
  final authStateController = StreamController<AuthState>();
  late SignUpCredentials _credentials;

  void showSignUp() {
    final state = AuthState(authFlowStatus: AuthFlowStatus.signUp);
    authStateController.add(state);
  }

  void showLogin() {
    final state = AuthState(authFlowStatus: AuthFlowStatus.login);
    authStateController.add(state);
  }

  Future<String> checkDup(String email) async {
    try {
      await CognitoService().userExist(email.toLowerCase());
    } on auth.UserNotFoundException catch (ex) {
      return 'ok';
    } on auth.UsernameExistsException catch (ex) {
      return 'ALREADY_EXIST';
    } on auth.NotAuthorizedException catch (ex) {
      return 'ALREADY_EXIST';
    } on auth.UserNotConfirmedException catch (ex) {
      return 'NOT_CONFIRMED';
    }
    return 'ok';
  }

  Future<String> sendAuthNumber(phoneNumber, dob, fullName) async {
    print(phoneNumber);
    try {
      final auth.SignUpResult code = await Amplify.Auth.signUp(
        username: userProvider.getEmail(),
        password: userProvider.getPassword(),
        options: auth.CognitoSignUpOptions(
          userAttributes: {
            'name': fullName,
            'address': '',
            'birthdate': dob,
            'email': userProvider.getEmail(),
            'nickname': userProvider.getNickname(),
            'phone_number': phoneNumber,
          },
        ),
      );
      if (code != null) {
        return 'ok';
      }
    } on auth.UsernameExistsException catch (ex) {
      return ex.message;
    } on auth.InvalidParameterException catch (ex) {
      return ex.message;
    }
    return '';
  }

  Future<String> verifyAuthNumber(vfc) async {
    try {
      var res = await Amplify.Auth.confirmSignUp(
        username: userProvider.getEmail(),
        confirmationCode: vfc,
      );
    } on auth.InvalidParameterException catch (ex) {
      return 'INVALID_PARAM';
    } on auth.CodeMismatchException catch (ex) {
      return 'CODE_MISMATCH';
    } on auth.NotAuthorizedException catch (ex) {
      return 'NOT_AUTHORIZED';
    } on auth.UnknownException catch (e) {
      print(e);
      return 'UNKNOWN_ERROR';
    }
    return 'ok';
  }

  void loginWithCredentials(AuthCredentials credentials) {
    final state = AuthState(authFlowStatus: AuthFlowStatus.session);
    authStateController.add(state);
  }

  Future<String> signIn() async {
    try {
      auth.SignInResult result = await Amplify.Auth.signIn(
        username: userProvider.getEmail(),
        password: userProvider.getPassword(),
      );
      if (result.isSignedIn) {
        signOut();
        return 'THIS USER IS ALREADY SIGNED IN';
      } else {
        return 'ok';
      }
      // else {
      //   return 'asdf';
      // }
      // auth.SignOutResult result = await Amplify.Auth.signOut();
      // try {
      //   final result = await Amplify.Auth.fetchAuthSession(
      //     options: auth.CognitoSessionOptions(
      //       getAWSCredentials: true,
      //     ),
      //   ) as auth.CognitoAuthSession;
      //   if (result.isSignedIn) {
      //     return 'ALREADY_SIGNED_IN';
      //   }
      //   return 'SIGNED_OUT';
      // } on auth.SignedOutException catch (ex) {
      //   return 'SIGNED_OUT_EXCEPTION';
      // } on auth.SessionExpiredException catch (ex) {
      //   return 'SESSION_EXPIRED';
      // } on auth.UserNotFoundException catch (ex) {
      //   return 'USER_NOT_FOUND';
      // } catch (e) {
      //   print(e);
      //   return 'UNKNOWN_EXCEPTION';
      // }
    } on auth.NotAuthorizedException catch (ex) {
      return ex.message;
    } on auth.SignedOutException catch (ex) {
      return 'SIGNED_OUT_EXCEPTION';
    } on auth.SessionExpiredException catch (ex) {
      return 'SESSION_EXPIRED';
    } on auth.UserNotFoundException catch (ex) {
      return 'USER_NOT_FOUND';
    } on auth.InvalidStateException catch (ex) {
      return 'INVALID_STATE';
    } catch (e) {
      print(e);
      return 'UNKNOWN_EXCEPTION';
    }
  }

  Future<void> signOut() async {
    try {
      await Amplify.Auth.signOut();
    } catch (e) {
      print(e);
    }
  }

  Future<String> getNickname() async {
    String _decodeBase64(String str) {
      String output = str.replaceAll('-', '+').replaceAll('_', '/');

      switch (output.length % 4) {
        case 0:
          break;
        case 2:
          output += '==';
          break;
        case 3:
          output += '=';
          break;
        default:
          throw Exception('Illegal base64url string!"');
      }

      return utf8.decode(base64Url.decode(output));
    }

    Map<String, dynamic> _parseJwt(String token) {
      final parts = token.split('.');
      if (parts.length != 3) {
        throw Exception('invalid token');
      }

      final payload = _decodeBase64(parts[1]);
      final payloadMap = json.decode(payload);
      if (payloadMap is! Map<String, dynamic>) {
        throw Exception('invalid payload');
      }

      return payloadMap;
    }

    try {
      final authState = await Amplify.Auth.fetchAuthSession(
              options: auth.CognitoSessionOptions(getAWSCredentials: true))
          as auth.CognitoAuthSession;
      if (authState.isSignedIn) {
        final claims = _parseJwt(authState.userPoolTokens!.idToken);
        final nickname = claims['nickname'] as String;
        return nickname;
      }
    } catch (e) {
      print(e);
    }
    return '';
  }

  void signUpWithCredentials(SignUpCredentials credentials) async {
    try {
      final userAttributes = {'email': credentials.email};

      final result = await Amplify.Auth.signUp(
        username: credentials.username,
        password: credentials.password,
        options: auth.CognitoSignUpOptions(
          userAttributes: userAttributes,
        ),
      );

      if (result.isSignUpComplete) {
        print('sex');
      } else {
        _credentials = credentials;

        final state = AuthState(authFlowStatus: AuthFlowStatus.verification);
        authStateController.add(state);
      }
    } on auth.AuthException catch (authError) {
      print('Failed to sign up - ${authError.message}');
    }
  }
}

class LoginCredential {
  void saveCredential(
      credential, isGoogle, isApple, email, name, nickname) async {
    try {
      String graphQLDocument =
          '''mutation CreateLoginCredential(\$credential: String!, \$isGoogle: Boolean!, \$isApple: Boolean!, \$email: String, \$name: String, \$nickname: String) {
              createLoginCredential(input: {credential: \$credential, isGoogle: \$isGoogle, isApple: \$isApple, email: \$email, name: \$name, nickname: \$nickname}) {
                id
                credential
                isGoogle
                isApple
                email
                name
                nickname
              }
        }''';
      var variables = {
        "credential": credential,
        "isGoogle": isGoogle,
        "isApple": isApple,
        "email": email,
        "name": name,
        "nickname": nickname
      };
      var request = GraphQLRequest<String>(
        document: graphQLDocument,
        variables: variables,
      );

      var operation = Amplify.API.mutate(request: request);
      var response = await operation.response;

      var data = response.data;
      print(data);
    } on ApiException catch (e) {
      print('Mutation failed: $e');
    }
  }
}

class AuthServiceThirdParty {
  Future<String> checkDup(cre) async {
    String graphQLDocument = '''query MyQuery {
      listLoginCredentials {
        items {
          id
          credential
        }
      }
    }''';
    try {
      var operation = Amplify.API.query<String>(
        request: GraphQLRequest(
          document: graphQLDocument,
        ),
      );

      var response = await operation.response;
      var list = List.from(
          json.decode(response.data)['listLoginCredentials']['items']);
      var i = 0;
      for (; i < list.length && !(list[i]['credential'] == cre); ++i);
      if (i < list.length) {
        return 'dup';
      } else {
        return 'no_dup';
      }
    } catch (e) {
      print(e);
      return 'error';
    }
  }

  Future<dynamic> getInfo(cre) async {
    String graphQLDocument = '''query MyQuery {
      listLoginCredentials {
        items {
          id
          credential
          email
          name
          nickname
        }
      }
    }''';

    var operation = Amplify.API
        .query<String>(request: GraphQLRequest(document: graphQLDocument));

    var response = await operation.response;
    var list =
        List.from(json.decode(response.data)['listLoginCredentials']['items']);
    var i = 0;
    for (; i < list.length && !(list[i]['credential'] == cre); ++i);

    if (i < list.length) {
      return [list[i]['email'], list[i]['name'], list[i]['nickname']];
    } else {
      return 'no_info';
    }
  }
}
