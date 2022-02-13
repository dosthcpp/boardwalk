import 'dart:io' show Platform;

import 'package:boardwalk/auth/auth_service.dart';
import 'package:boardwalk/main.dart';
import 'package:boardwalk/screens/sign_up.dart';
import 'package:boardwalk/screens/login.dart';

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:boardwalk/screens/exception.dart' show ExceptionPage;
import 'package:boardwalk/screens/home.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart' as apple;

class LandingScreen extends StatefulWidget {
  static const String id = 'landing_screen';

  const LandingScreen({Key? key}) : super(key: key);

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final _authServiceThirdParty = AuthServiceThirdParty();
  final _loginCredential = LoginCredential();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      final _authService = AuthService();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? email = prefs.getString('curEmail');
      if(email != null && email.isNotEmpty) {
        // String? passwd = await storage.read(key: email);
        Map<String, dynamic> result = await _authService.restore(email);
        if(result['claims'] == 'EXCEPTION'){
          Navigator.pushNamed(context, ExceptionPage.id);
        } else if(result['claims'] == null) {
          // do nothing
        } else {
          userProvider.setEmail(email);
          userProvider.setNickname(await _authService.getNickname());
          Navigator.pushNamed(context, Home.id);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.3), BlendMode.darken),
              child: Image.asset(
                'assets/jogging_1.webp',
                fit: BoxFit.cover,
                alignment: const Alignment(
                  -0.45,
                  0,
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Align(
                alignment: Alignment.center,
                child: Text(
                  "Boardwalk",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 35.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Column(
                children: [
                  InkWell(
                    onTap: () async {
                      try {
                        GoogleSignInAccount? account =
                            await googleSignIn.signIn();
                        if (account != null) {
                          String result = await _authServiceThirdParty
                              .checkDup(account.id);
                          if(result == 'error') {
                            AwesomeDialog(
                              context: context,
                              animType: AnimType.SCALE,
                              dialogType: DialogType.ERROR,
                              btnOk: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.indigo,
                                ),
                                child: const Text(
                                  'Confirm',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              body: const Center(
                                child: Text(
                                  'An error occured...',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              btnOkOnPress: () {},
                            ).show();
                            return;
                          }
                          bool isDup = result ==
                              'dup';
                          if (isDup) {
                            AwesomeDialog(
                              context: context,
                              animType: AnimType.SCALE,
                              dialogType: DialogType.ERROR,
                              btnOk: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.indigo,
                                ),
                                child: const Text(
                                  'Confirm',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              body: const Center(
                                child: Text(
                                  'This id is already signed up.\nPlease go to sign in page.',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              btnOkOnPress: () {},
                            ).show();
                          } else {
                            _loginCredential.saveCredential(
                                account.id,
                                true,
                                false,
                                account.email,
                                account.displayName,
                                'Anonymous');
                            AwesomeDialog(
                              context: context,
                              animType: AnimType.SCALE,
                              dialogType: DialogType.SUCCES,
                              btnOk: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.indigo,
                                ),
                                child: const Text(
                                  'Confirm',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              body: const Center(
                                child: Text(
                                  'Successfully signed up!',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              btnOkOnPress: () {},
                            ).show();
                          }
                        }
                        await googleSignIn.signOut();
                      } catch (e, msg) {
                        print(e);
                        print(msg);
                      }
                    },
                    child: Container(
                      width: 250.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          100.0,
                        ),
                        color: Colors.black.withOpacity(0.5),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 8.0,
                          ),
                          Image.asset(
                            'assets/google.png',
                            scale: 18.0,
                          ),
                          const SizedBox(
                            width: 20.0,
                          ),
                          RichText(
                            textAlign: TextAlign.center,
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Sign up with ',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Google',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Platform.isIOS
                      ? Container(
                          width: 250.0,
                          height: 50.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              100.0,
                            ),
                            color: Colors.black.withOpacity(0.5),
                          ),
                          child: InkWell(
                            onTap: () async {
                              try {
                                if (await apple.SignInWithApple.isAvailable()) {
                                  final credential = await apple.SignInWithApple
                                      .getAppleIDCredential(scopes: [
                                    apple.AppleIDAuthorizationScopes.email,
                                    apple.AppleIDAuthorizationScopes.fullName,
                                  ]);
                                  String? email = credential.email != null
                                      ? credential.email
                                      : '';
                                  String? fullName = credential.givenName !=
                                              null &&
                                          credential.familyName != null
                                      ? '${credential.givenName} ${credential.familyName}'
                                      : '';
                                  bool isDup =
                                      await _authServiceThirdParty.checkDup(
                                              credential.userIdentifier) ==
                                          'dup';
                                  if (isDup) {
                                    AwesomeDialog(
                                      context: context,
                                      animType: AnimType.SCALE,
                                      dialogType: DialogType.ERROR,
                                      btnOk: ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.indigo,
                                        ),
                                        child: const Text(
                                          'Confirm',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      body: const Center(
                                        child: Text(
                                          'This id is already signed up.\nPlease go to sign in page.',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      btnOkOnPress: () {},
                                    ).show();
                                  } else {
                                    _loginCredential.saveCredential(
                                      credential.userIdentifier,
                                      false,
                                      true,
                                      email,
                                      fullName,
                                      'Anonymous',
                                    );
                                    AwesomeDialog(
                                      context: context,
                                      animType: AnimType.SCALE,
                                      dialogType: DialogType.SUCCES,
                                      btnOk: ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.indigo,
                                        ),
                                        child: const Text(
                                          'Confirm',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      body: const Center(
                                        child: Text(
                                          'Successfully signed up!',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      btnOkOnPress: () {},
                                    ).show();
                                  }
                                }
                              } catch (e) {
                                print(e);
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  width: 8.0,
                                ),
                                Image.asset(
                                  'assets/apple.png',
                                  scale: 18.0,
                                  color: Colors.white,
                                ),
                                const SizedBox(
                                  width: 20.0,
                                ),
                                RichText(
                                  textAlign: TextAlign.center,
                                  text: const TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Sign up with ',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'Apple',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : SizedBox(),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    width: 250.0,
                    height: 50.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        100.0,
                      ),
                      color: Colors.black.withOpacity(0.5),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, SignUpScreen.id);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(
                            width: 8.0,
                          ),
                          Image.asset(
                            'assets/email.png',
                            color: Colors.white,
                            scale: 18.0,
                          ),
                          const SizedBox(
                            width: 20.0,
                          ),
                          RichText(
                            textAlign: TextAlign.center,
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Sign up with ',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Email',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Already signed up?",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, LoginPage.id);
                          },
                          child: const Text(
                            "Sign in",
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
