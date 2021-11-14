import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

class CustomOIDCProvider extends OIDCAuthProvider {
  const CustomOIDCProvider();

  @override
  Future<String?> getLatestAuthToken() async {
    final session = await Amplify.Auth.fetchAuthSession() as CognitoAuthSession;
    return session.userPoolTokens?.idToken;
  }

}