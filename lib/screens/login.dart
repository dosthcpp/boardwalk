import 'dart:io' show Platform;

import 'dart:async';
import 'dart:convert';

import 'package:boardwalk/auth/auth_service.dart';
import 'package:boardwalk/main.dart';
import 'package:boardwalk/screens/home.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart' as apple;
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  static const id = 'login_page';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isObscure = true;
  String status = '';
  final _authService = AuthService();
  final _authServiceThirdParty = AuthServiceThirdParty();
  final _loginCredential = LoginCredential();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.05,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.arrow_back,
                  size: 50.0,
                ),
              ),
            ),
            const Divider(
              height: 30.0,
              thickness: 2.0,
              color: Colors.black26,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Sign in",
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                const Text(
                  "Welcome back!",
                ),
                const SizedBox(
                  height: 30.0,
                ),
                Center(
                  child: SizedBox(
                    height: 50.0,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          50,
                        ),
                      ),
                      disabledColor: Colors.grey,
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.1,
                          ),
                          Transform(
                            transform:
                                Matrix4.translationValues(-30, 0.0, 0.0),
                            child: Image.asset(
                              'assets/google.png',
                              scale: 25.0,
                            ),
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          RichText(
                            textAlign: TextAlign.center,
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Continue with ',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Google',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      onPressed: () async {
                        try {
                          GoogleSignInAccount? account = await googleSignIn.signIn();
                          if (account != null) {
                            var info =
                            await _authServiceThirdParty.getInfo(account.id);
                            if(info == 'no_info') {
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
                                    'You are not registered with this service.',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                btnOkOnPress: () {},
                              ).show();
                            } else {
                              userProvider.setEmail(info[0]);
                              userProvider.setName(info[1]);
                              userProvider.setNickname(info[2]);
                              Navigator.pushNamed(context, Home.id);
                            }
                          }
                        } catch (e) {
                          print(e);
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Platform.isIOS ? Center(
                  child: SizedBox(
                    height: 50.0,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          50,
                        ),
                      ),
                      disabledColor: Colors.grey,
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.1,
                          ),
                          Transform(
                            transform:
                            Matrix4.translationValues(-30, 0.0, 0.0),
                            child: Image.asset(
                              'assets/apple.png',
                              scale: 25.0,
                            ),
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          RichText(
                            textAlign: TextAlign.center,
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Continue with ',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Apple',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      onPressed: () async {
                        try {
                          if (await apple.SignInWithApple.isAvailable()) {
                            final credential =
                            await apple.SignInWithApple.getAppleIDCredential(
                                scopes: [
                                  apple.AppleIDAuthorizationScopes.email,
                                  apple.AppleIDAuthorizationScopes.fullName,
                                ]);
                            var info =
                            await _authServiceThirdParty.getInfo(credential.userIdentifier);
                            if(info == 'no_info') {
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
                                    'You are not registered with this service.',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                btnOkOnPress: () {},
                              ).show();
                            } else {
                              userProvider.setEmail(info[0]);
                              userProvider.setName(info[1]);
                              userProvider.setNickname(info[2]);
                              Navigator.pushNamed(context, Home.id);
                            }
                          }
                        } catch(e) {
                          print(e);
                        }
                      },
                    ),
                  ),
                ) : SizedBox(),
              ],
            ),
            const SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.13,
                  child: const Divider(
                    height: 30.0,
                    thickness: 2.0,
                    color: Colors.black26,
                  ),
                ),
                const Center(
                  child: Text(
                    "or continue to sign in with email",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.13,
                  child: const Divider(
                    height: 30.0,
                    thickness: 2.0,
                    color: Colors.black26,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20.0,
            ),
            TextField(
              decoration: const InputDecoration(
                hintText: "Email",
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black26),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black26),
                ),
              ),
              onChanged: (email) {
                userProvider.setEmail(email);
              },
            ),
            const SizedBox(
              height: 20.0,
            ),
            Stack(
              children: [
                TextField(
                  obscureText: isObscure,
                  decoration: const InputDecoration(
                    hintText: "Password",
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black26),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black26),
                    ),
                  ),
                  onChanged: (password) {
                    userProvider.setPassword(password);
                  },
                ),
                Positioned(
                  right: 0.0,
                  top: 12.0,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        isObscure = !isObscure;
                      });
                    },
                    child: Icon(
                      isObscure ? Icons.remove : Icons.remove_red_eye,
                      color: Colors.black54,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 5.0,
            ),
            status.isNotEmpty
                ? Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      status,
                      style: const TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  )
                : SizedBox(),
            const SizedBox(
              height: 5.0,
            ),
            const SizedBox(
              height: 10.0,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: () {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.NO_HEADER,
                    animType: AnimType.SCALE,
                    btnCancelText: "Cancel",
                    btnOkText: "Send a recovery email",
                    body: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Forgot your password?',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          TextField(
                            decoration: InputDecoration(
                              hintText: "Email address",
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black26),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black26),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            "Forgot your email?",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Please send email to contact@boardwalk.team and we will help you as soon as possible.",
                          ),
                        ],
                      ),
                    ),
                    btnCancelOnPress: () {},
                    btnOkOnPress: () {},
                  ).show();
                },
                child: const Text(
                  "Forgot your password?",
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.15,
            ),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text:
                    'If you proceed, it will be considered to have\nagreed to ',
                style: const TextStyle(color: Colors.black),
                children: [
                  TextSpan(
                    text: 'the terms and conditions of use',
                    style: const TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        print('Tap Here onTap');
                      },
                  ),
                  const TextSpan(
                    text: '\nand ',
                  ),
                  TextSpan(
                    text: 'personal information use',
                    style: const TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        print('Tap Here onTap');
                      },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            SizedBox(
              height: 50.0,
              width: MediaQuery.of(context).size.width * 0.8,
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    50,
                  ),
                ),
                disabledColor: Colors.grey,
                color: Colors.indigo,
                child: const Text(
                  "Sign in",
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
                onPressed: () async {
                  String message = await _authService.signIn();
                  if (message == 'ok') {
                    userProvider.setNickname(await _authService.getNickname());
                    Navigator.pushNamed(context, Home.id);
                  } else {
                    setState(() {
                      status = message;
                    });

                    Future.delayed(const Duration(seconds: 2), () {
                      setState(() {
                        status = '';
                      });
                    });
                  }
                  // switch (await _authService.checkStatus()) {
                  //   case 'SIGNED_OUT':
                  //     setState(() {
                  //       status = 'ERROR: USER_SIGNED_OUT';
                  //     });
                  //     break;
                  //   case 'USER_NOT_FOUND':
                  //     setState(() {
                  //       status = 'ERROR: USER_NOT_FOUND';
                  //     });
                  //     break;
                  //   case 'SESSION_EXPIRED':
                  //     break;
                  //   case 'SIGNED_OUT_EXCEPTION':
                  //     signInProc();
                  //     break;
                  //   case 'ALREADY_SIGNED_IN':
                  //     await _authService.signOut();
                  //     signInProc();
                  //     break;
                  //   default:
                  //     break;
                  // }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
