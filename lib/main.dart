import 'package:boardwalk/providers/map.dart';
import 'package:boardwalk/screens/exception.dart';
import 'package:boardwalk/screens/forgot_password.dart';
import 'package:boardwalk/test/scan_loc.dart';
import 'package:flutter/material.dart';

import 'package:boardwalk/api/api_service.dart';
import 'package:boardwalk/providers/user.dart';
import 'package:boardwalk/screens/create_spot.dart';
import 'package:boardwalk/screens/detail.dart';
import 'package:boardwalk/screens/home.dart';
import 'package:boardwalk/screens/review.dart';
import 'package:boardwalk/screens/login.dart';
import 'package:boardwalk/screens/sign_up.dart';
import 'package:boardwalk/screens/welcome_screen.dart';
import 'package:boardwalk/screens/landing_screen.dart';
import 'package:boardwalk/screens/profile_and_settings.dart';
import 'package:boardwalk/screens/exception.dart' show ExceptionPage;
import 'package:boardwalk/test/test_page.dart';
import 'package:boardwalk/test/test_page_session_detail.dart';
import 'package:flutter/scheduler.dart';

import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:boardwalk/amplifyconfiguration.dart' show amplifyconfig;

import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_core/amplify_core.dart' as core;
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:amplify_api/amplify_api.dart';

final userProvider = UserProvider();
final sessionProvider = SessionProvider();
final mapProvider = MapProvider();

final GoogleSignIn googleSignIn = GoogleSignIn(scopes: [
  'email',
  'https://www.googleapis.com/auth/user.addresses.read',
]);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>(
          create: (_) => userProvider,
        ),
        ChangeNotifierProvider<SessionProvider>(
          create: (_) => sessionProvider,
        ),
        ChangeNotifierProvider<MapProvider>(
          create: (_) => mapProvider,
        )
      ],
      child: const BoardWalk(),
    ),
  );
}

class BoardWalk extends StatefulWidget {
  const BoardWalk({Key? key}) : super(key: key);

  @override
  State<BoardWalk> createState() => _BoardWalkState();
}

class _BoardWalkState extends State<BoardWalk> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    configureAmplify();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      print('asdf');
    }
  }

  void configureAmplify() async {
    if (!mounted) return;
    try {
      AmplifyAuthCognito auth = AmplifyAuthCognito();
      AmplifyAPI api = AmplifyAPI();
      AmplifyStorageS3 storage = AmplifyStorageS3();
      await Amplify.addPlugins([
        auth,
        api,
        storage,
      ]);

      // Amplify.Hub.listen([HubChannel.Auth], (event) {});
      try {
        if (!Amplify.isConfigured) {
          await Amplify.configure(amplifyconfig);
        }
      } on core.AmplifyAlreadyConfiguredException catch (e, stacktrace) {
        print(e);
        print('Amplify was already configured. Looks like app restarted on android.');
      }
      print('Successfully configured Amplify!');
    } catch (e, stacktrace) {
      print(e);
      print('Could not configure Amplify ☠️');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: LandingScreen.id,
      routes: {
        ExceptionPage.id: (context) => ExceptionPage(),
        LandingScreen.id: (context) => const LandingScreen(),
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginPage.id: (context) => LoginPage(),
        Home.id: (context) => Home(),
        Detail.id: (context) => const Detail(),
        Review.id: (context) => const Review(),
        ProfileAndSettings.id: (context) => const ProfileAndSettings(),
        CreateSpot.id: (context) => const CreateSpot(),
        TestPage.id: (context) => TestPage(),
        TestPageSessionDetail.id: (context) => TestPageSessionDetail(),
        SignUpScreen.id: (context) => SignUpScreen(),
        ForgotPassword.id: (context) => const ForgotPassword(),
        ScanLocation.id: (context) => ScanLocation(),
      },
    );
  }
}
