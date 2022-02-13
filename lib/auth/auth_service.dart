import 'dart:async';
import 'dart:convert';
import 'package:boardwalk/auth/auth_credentials.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart' as auth;
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:boardwalk/main.dart';
import 'package:amazon_cognito_identity_dart_2/cognito.dart';

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
  final storage = FlutterSecureStorage();
  late var _credentials;

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

  Future<String> sendAuthNumber(password, phoneNumber, dob, fullName) async {
    try {
      final auth.SignUpResult code = await Amplify.Auth.signUp(
        username: userProvider.getEmail(),
        password: password,
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

  Future<bool> hasSignedIn() async {
    // final auth.CognitoAuthSession authState =
    //     await Amplify.Auth.fetchAuthSession(
    //   options: auth.CognitoSessionOptions(
    //     getAWSCredentials: true,
    //   ),
    // ) as auth.CognitoAuthSession;
    // print(authState.isSignedIn);
    return false;
    // return authState.isSignedIn;
  }

  toggleSignIn(bool signedIn) async {
    try {
      String queryDoc = '''query MyQuery {
      listSignIns {
        items {
          id
          email
          signedIn
        }
      }
    }''';

      var operation = Amplify.API
          .query<String>(request: GraphQLRequest(document: queryDoc));

      var response = await operation.response;
      final List<dynamic> signIns =
      jsonDecode(response.data)['listSignIns']['items'];
      final emailMatch = signIns
          .indexWhere((el) => el['email'] == userProvider.getEmail());
      final id = signIns[emailMatch]['id'];
      print(id);
      String graphQLDocument =
      '''mutation UpdateSignIn(\$id: ID!, \$email: String, \$signedIn: Boolean!) {
          updateSignIn(input: {id: \$id, email: \$email, signedIn: \$signedIn}) {
            id
            email
            signedIn
          }
      }''';

      Amplify.API.mutate(
        request: GraphQLRequest<String>(
          document: graphQLDocument,
          variables: {
            'id': id,
            'email': userProvider.getEmail(),
            'signedIn': signedIn,
          },
        ),
      );
    } on ApiException catch (e) {
      print('Mutation failed: $e');
    }
  }

  Future<String> signIn(password) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('curEmail', userProvider.getEmail());
      await Amplify.Auth.signIn(
        username: userProvider.getEmail(),
        password: password,
      );
      await storage.write(key: userProvider.getEmail(), value: password);
      // mutation lock
      toggleSignIn(true);

      return 'ok';
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
    } on auth.UserNotFoundException catch (ex) {
      return 'USER_NOT_FOUND';
    } on auth.NotAuthorizedException catch (ex) {
      return 'WRONG USERNAME OR PASSWORD!';
    } on auth.InvalidStateException catch (ex) {
      return 'INVALID_STATE';
    } on auth.SignedOutException catch (ex) {
      return 'SIGNED_OUT_EXCEPTION';
    } on auth.SessionExpiredException catch (ex) {
      return 'SESSION_EXPIRED';
    } catch (e) {
      return 'UNKNOWN_EXCEPTION';
    }
  }

  Future<Map<String, dynamic>> restore(email) async {
    try {
      final result = await Amplify.Auth.fetchAuthSession(
        options: auth.CognitoSessionOptions(
          getAWSCredentials: true,
        ),
      ) as auth.CognitoAuthSession;

      if (result.isSignedIn) {
        final claims = Jwt.parseJwt(result.userPoolTokens!.idToken);

        return {'claims': claims};
      } else {
        return {'claims': null};
      }
    } catch (e) {
      return {'claims': 'EXCEPTION'};
    }
  }

  Future<void> signOut(_global) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('curEmail');
      await toggleSignIn(false);
      await storage.delete(key: userProvider.getEmail());
      await Amplify.Auth.signOut(
          options: auth.SignOutOptions(
        globalSignOut: _global,
      ));
      userProvider.clear();
    } catch (e, stacktrace) {
      print(stacktrace);
    }
  }

  checkSignedIn(email) async {
    try {
      String graphQLDocument = '''query MyQuery {
      listSignIns {
        items {
          id
          email
          signedIn
        }
      }
    }''';

      var operation = Amplify.API
          .query<String>(request: GraphQLRequest(document: graphQLDocument));

      var response = await operation.response;
      final List<dynamic> signIns =
          jsonDecode(response.data)['listSignIns']['items'];
      try {
        print(signIns);
        final hasSignedIn =
            signIns[signIns.indexWhere((el) => el['email'] == email)]
                ['signedIn'];
        return hasSignedIn;
      } on ApiException catch (e) {
        print('Api Exception');
      } catch (e) {
        // out of index
        print('email not exist');
        return null;
      }
      // return response.data;
    } catch (e) {
      print(e);
    }
  }

  createSignInModel(email) async {
    try {
      String graphQLDocument =
          '''mutation CreateSignIn(\$email: String, \$signedIn: Boolean!) {
              createSignIn(input: {email: \$email, signedIn: \$signedIn}) {
                id
                email
                signedIn
              }
        }''';
      var variables = {
        "email": email,
        "signedIn": false,
      };
      var request = GraphQLRequest<String>(
        document: graphQLDocument,
        variables: variables,
      );

      var operation = Amplify.API.mutate(request: request);
      var response = await operation.response;

      var data = response.data;
    } on ApiException catch (e) {
      print('Mutation failed: $e');
    }
    // try {
    //   // final auth.CognitoAuthSession authState =
    //   //     await Amplify.Auth.fetchAuthSession(
    //   //             options: auth.CognitoSessionOptions(getAWSCredentials: true))
    //   //         as auth.CognitoAuthSession;
    //   // // print(_parseJwt(authState.userPoolTokens!.accessToken));
    //   // print(Jwt.isExpired(authState.userPoolTokens!.accessToken));
    //   // // print(authState.userPoolTokens!.refreshToken);
    //   // // print(Jwt.parseJwt(authState.userPoolTokens!.refreshToken));
    //   // // print(_parseJwt(authState.credentials!.sessionToken!);
    //   final cognitoUser = CognitoUser('drakedog19@gmail.com', userPool);
    //   final authDetails = AuthenticationDetails(
    //     username: 'drakedog19@gmail.com',
    //     password: 'Tnthd001!!',
    //   );
    //   CognitoUserSession? session;
    //   try {
    //     final awsUser = await Amplify.Auth.getCurrentUser();
    //     print((await Amplify.Auth.fetchAuthSession()));
    //     print(awsUser);
    //     // Amplify.Hub.listen([HubChannel.Auth], (event) {
    //     //
    //     // });
    //     // session = await cognitoUser.authenticateUser(authDetails);
    //     // print(session?.idToken.getIss());
    //   } catch (e) {
    //     print(e);
    //   }
    // } catch (e) {
    //   print(e);
    // }
  }

  Future<String> getNickname() async {
    try {
      final authState = await Amplify.Auth.fetchAuthSession(
              options: auth.CognitoSessionOptions(getAWSCredentials: true))
          as auth.CognitoAuthSession;
      if (authState.isSignedIn) {
        final claims = Jwt.parseJwt(authState.userPoolTokens!.idToken);
        final nickname = claims['nickname'] as String;
        return nickname;
      }
    } catch (e) {
      print(e);
    }
    return 'Anonymous';
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
