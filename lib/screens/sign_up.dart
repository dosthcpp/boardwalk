import 'dart:async';
import 'dart:io' show Platform;

import 'package:boardwalk/auth/auth_service.dart';
import 'package:boardwalk/main.dart';
import 'package:boardwalk/screens/landing_screen.dart';
import 'package:boardwalk/screens/welcome_screen.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUpScreen extends StatefulWidget {
  static const id = 'signup_screen';
  bool isGoogleSignIn, isAppleSignIn;

  SignUpScreen({
    Key? key,
    this.isGoogleSignIn = false,
    this.isAppleSignIn = false,
  }) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  String countryCode = '82';
  String lastName = '';
  String firstName = '';
  final _authService = AuthService();
  bool verificationBtnClicked = false;
  final TextEditingController phoneNumberTE = TextEditingController(
    text: '010',
  );
  final TextEditingController dob = TextEditingController();

  bool hasUppercase = false;
  bool hasDigits = false;
  bool hasLowercase = false;
  bool hasSpecialCharacters = false;
  bool hasMinLength = false;

  Timer _timer = Timer(const Duration(milliseconds: 0), () {});
  final interval = const Duration(seconds: 1);
  final int timerMaxSeconds = 180;
  int currentSeconds = 0;

  String get timerText =>
      '${((timerMaxSeconds - currentSeconds) ~/ 60).toString().padLeft(2, '0')}: ${((timerMaxSeconds - currentSeconds) % 60).toString().padLeft(2, '0')}';
  String authCodeStatus = '';
  String verificationCode = '';
  bool verified = false;

  startTimeout() {
    _timer = Timer.periodic(interval, (timer) {
      setState(() {
        currentSeconds = timer.tick;
        if (timer.tick >= timerMaxSeconds) timer.cancel();
      });
    });
  }

  DateTime selectedDate = DateTime.now();

  String get dateText =>
      '${selectedDate.month > 10 ? selectedDate.month : '0${selectedDate.month}'}-${selectedDate.day > 10 ? selectedDate.day : '0${selectedDate.day}'}-${selectedDate.year}';

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = Platform.isAndroid
        ? await showDatePicker(
            context: context,
            initialDate: selectedDate,
            firstDate: DateTime(1960),
            lastDate: DateTime(2101),
          )
        : await showCupertinoModalPopup(
            context: context,
            builder: (_) => Container(
              height: 500,
              color: Color.fromARGB(255, 255, 255, 255),
              child: Column(
                children: [
                  Container(
                    height: 400,
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.date,
                      initialDateTime: selectedDate,
                      onDateTimeChanged: (val) {
                        setState(
                          () {
                            selectedDate = val;
                            dob.text = dateText;
                          },
                        );
                      },
                    ),
                  ),

                  // Close the modal
                  CupertinoButton(
                    child: Text('OK'),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              ),
            ),
          );

    if (Platform.isAndroid && picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        dob.text = dateText;
      });
  }

  showToast(msg) {
    Fluttertoast.showToast(
      backgroundColor: Colors.black.withOpacity(0.5),
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 10.0,
                  ),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "Welcome!",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30.0,
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  "sign up",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                right: 10.0,
                              ),
                              child: IconButton(
                                onPressed: () {
                                  userProvider.clear();
                                  Navigator.pop(context);
                                },
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.black,
                                  size: 40.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          right: 50.0,
                        ),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 50.0,
                            ),
                            CustomTextField(
                              hintText: "Nickname",
                              onChanged: (nickname) {
                                userProvider.setNickname(nickname);
                              },
                            ),
                            CustomTextField(
                              hintText: "Last name",
                              onChanged: (ln) {
                                lastName = ln;
                              },
                            ),
                            CustomTextField(
                              hintText: "First name",
                              onChanged: (fn) {
                                firstName = fn;
                              },
                            ),
                            CustomTextField(
                                te: dob,
                                hintText: "Date of Birth",
                                onTap: () {
                                  _selectDate(context);
                                }),
                            const SizedBox(
                              height: 10.0,
                            ),
                            const Center(
                              child: Text(
                                "Get a special thing every year on your Birthday.",
                                style: TextStyle(
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                            CustomTextField(
                              hintText: "Email address",
                              onChanged: (addr) {
                                userProvider.setEmail(addr);
                              },
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Column(
                              children: [
                                TextFormField(
                                  onChanged: (password) {
                                    userProvider.setPassword(password);
                                  },
                                  autovalidateMode: AutovalidateMode.always,
                                  validator: (password) {
                                    if (password == null || password.isEmpty) {
                                      SchedulerBinding.instance!
                                          .addPostFrameCallback((_) {
                                        setState(() {
                                          hasUppercase = false;
                                          hasDigits = false;
                                          hasLowercase = false;
                                          hasSpecialCharacters = false;
                                          hasMinLength = false;
                                        });
                                      });
                                      return null;
                                    } else {
                                      bool _hasUppercase =
                                          password.contains(RegExp(r'[A-Z]'));
                                      bool _hasDigits =
                                          password.contains(RegExp(r'[0-9]'));
                                      bool _hasLowercase =
                                          password.contains(RegExp(r'[a-z]'));
                                      bool _hasSpecialCharacters =
                                          password.contains(RegExp(
                                              r'[!@#$%^&*(),.?":{}|<>]'));
                                      bool _hasMinLength = password.length >= 8;

                                      SchedulerBinding.instance!
                                          .addPostFrameCallback((_) {
                                        setState(() {
                                          hasUppercase = _hasUppercase;
                                          hasDigits = _hasDigits;
                                          hasLowercase = _hasLowercase;
                                          hasSpecialCharacters =
                                              _hasSpecialCharacters;
                                          hasMinLength = _hasMinLength;
                                          if (_hasUppercase &&
                                              _hasDigits &&
                                              _hasLowercase &&
                                              _hasSpecialCharacters &&
                                              _hasMinLength) {}
                                        });
                                      });
                                    }

                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    hintText: "Enter your password.",
                                    hintStyle: TextStyle(
                                      color: Colors.black54,
                                    ),
                                  ),
                                  obscureText: true,
                                ),
                                const SizedBox(
                                  height: 17.5,
                                ),
                                Visibility(
                                  visible: !(hasUppercase &&
                                      hasDigits &&
                                      hasLowercase &&
                                      hasSpecialCharacters &&
                                      hasMinLength),
                                  child: Column(
                                    children: [
                                      PasswordFactor(
                                        satisfied: hasUppercase,
                                        desc:
                                            'The password has uppercase character.',
                                      ),
                                      PasswordFactor(
                                        satisfied: hasLowercase,
                                        desc:
                                            'The password has a lowercase character.',
                                      ),
                                      PasswordFactor(
                                        satisfied: hasDigits,
                                        desc: 'The password has digits.',
                                      ),
                                      PasswordFactor(
                                        satisfied: hasSpecialCharacters,
                                        desc:
                                            'The password has a special character.',
                                      ),
                                      PasswordFactor(
                                        satisfied: hasMinLength,
                                        desc:
                                            'The password length is at least 8.',
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Stack(
                              children: [
                                Offstage(
                                  offstage: verificationBtnClicked,
                                  child: TickerMode(
                                    enabled: !verificationBtnClicked,
                                    child: Stack(
                                      children: [
                                        Form(
                                          key: _formKey,
                                          child: TextFormField(
                                            controller: phoneNumberTE,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Enter your phone number.';
                                              }
                                              RegExp regex = RegExp(
                                                  r'^\d{3}\d{3,4}\d{4}$');
                                              if (!regex.hasMatch((value))) {
                                                return 'Invalid phone number!';
                                              }
                                              return null;
                                            },
                                            decoration: const InputDecoration(
                                              hintText:
                                                  "Enter your phone number.",
                                              hintStyle: TextStyle(
                                                color: Colors.black54,
                                              ),
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                horizontal: 40.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Transform(
                                          transform: Matrix4.translationValues(
                                              0.0, 15.0, 0.0),
                                          child: InkWell(
                                            child: Text("+$countryCode"),
                                            onTap: () {
                                              showCountryPicker(
                                                context: context,
                                                showPhoneCode: true,
                                                // optional. Shows phone code before the country name.
                                                onSelect: (Country country) {
                                                  setState(
                                                    () {
                                                      countryCode =
                                                          country.phoneCode;
                                                    },
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                        Transform(
                                          transform: Matrix4.translationValues(
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.7,
                                              0.0,
                                              0.0),
                                          child: Stack(
                                            children: [
                                              Offstage(
                                                offstage:
                                                    verificationBtnClicked,
                                                child: TickerMode(
                                                  enabled:
                                                      !verificationBtnClicked,
                                                  child: MaterialButton(
                                                    onPressed: () async {
                                                      if (_formKey.currentState!
                                                              .validate() &&
                                                          firstName
                                                              .isNotEmpty &&
                                                          lastName.isNotEmpty &&
                                                          selectedDate !=
                                                              DateTime.now() &&
                                                          userProvider
                                                              .getEmail()
                                                              .isNotEmpty &&
                                                          userProvider
                                                              .getPassword()
                                                              .isNotEmpty) {
                                                        if (_timer.isActive) {
                                                          _timer.cancel();
                                                        }
                                                        var phoneNumber =
                                                            '+$countryCode${phoneNumberTE.text.substring(1)}';
                                                        try {
                                                          print(phoneNumber);
                                                          var code =
                                                              await _authService
                                                                  .sendAuthNumber(
                                                            phoneNumber,
                                                            dob.text,
                                                            '$lastName$firstName}',
                                                          );
                                                          switch (code) {
                                                            case 'ALREADY_EXIST':
                                                              break;
                                                            case 'Username is required to signUp':
                                                              showToast(
                                                                  'Email is required to signUp');
                                                              break;
                                                            case 'An account with the given email already exists.':
                                                            case 'Password is required to signUp':
                                                              showToast(code);
                                                              break;
                                                            case 'ok':
                                                              startTimeout();
                                                              setState(() {
                                                                verificationBtnClicked =
                                                                    true;
                                                              });
                                                              break;
                                                            default:
                                                              print(code);
                                                              break;
                                                          }
                                                        } catch (e) {
                                                          print(e);
                                                        }
                                                      } else {
                                                        Fluttertoast.showToast(
                                                          backgroundColor:
                                                              Colors.black
                                                                  .withOpacity(
                                                                      0.5),
                                                          msg:
                                                              'Please fill all textfields.',
                                                          toastLength: Toast
                                                              .LENGTH_SHORT,
                                                          gravity: ToastGravity
                                                              .BOTTOM,
                                                          timeInSecForIosWeb: 1,
                                                        );
                                                      }
                                                    },
                                                    child: const Text(
                                                      "Verify",
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Offstage(
                                  offstage: !verificationBtnClicked,
                                  child: TickerMode(
                                    enabled: verificationBtnClicked,
                                    child: Stack(
                                      children: [
                                        TextFormField(
                                          decoration: const InputDecoration(
                                            hintText: "Authorization number",
                                            hintStyle: TextStyle(
                                              color: Colors.black54,
                                            ),
                                          ),
                                          onChanged: (vfc) {
                                            verificationCode = vfc;
                                          },
                                          textAlign: TextAlign.left,
                                        ),
                                        Visibility(
                                          visible: !verified &&
                                              timerText != "00: 00" &&
                                              timerText != "03: 00",
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Transform(
                                              transform:
                                                  Matrix4.translationValues(
                                                      -50.0, 15, 0),
                                              child: Text(
                                                timerText,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Transform(
                                            transform:
                                                Matrix4.translationValues(
                                                    20, 0, 0),
                                            child: !verified
                                                ? MaterialButton(
                                                    child: const Text(
                                                      "Verify",
                                                    ),
                                                    onPressed: () async {
                                                      String status =
                                                          await _authService
                                                              .verifyAuthNumber(
                                                                  verificationCode);
                                                      switch (status) {
                                                        case 'INVALID_PARAM':
                                                          showToast(
                                                              'Invalid parameter!');
                                                          break;
                                                        case 'CODE_MISMATCH':
                                                          showToast(
                                                              'Code mismatch! Plase re-enter the code!');
                                                          break;
                                                        case 'NOT_AUTHORIZED':
                                                          showToast(
                                                              'The user is already confirmed.');
                                                          break;
                                                        case 'UNKNOWN_ERROR':
                                                          showToast(
                                                              'Unknown error! Please contact the admin.');
                                                          break;
                                                        case 'ok':
                                                          // verified
                                                          showToast(
                                                              'Your phone number is successfully verified!');
                                                          setState(() {
                                                            verified = true;
                                                          });
                                                          break;
                                                        default:
                                                          break;
                                                      }
                                                    },
                                                  )
                                                : Transform(
                                                    transform: Matrix4
                                                        .translationValues(
                                                            -15.0, 15.0, 0.0),
                                                    child: const Text(
                                                      "Verified!",
                                                      style: TextStyle(
                                                        color: Colors.green,
                                                      ),
                                                    ),
                                                  ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 40.0,
                      ),
                      Center(
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text:
                                'By creating an account, you agree to Boardwalk\'s\n',
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(
                                text: 'Terms and Conditions',
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
                                text: ' and ',
                              ),
                              TextSpan(
                                text: 'Privacy Statement',
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
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (!verified) {
                      showToast('Please verify your phone first.');
                    } else {
                      Navigator.pushNamed(context, WelcomeScreen.id);
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(
                      right: 10.0,
                    ),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.black54,
                        size: 50.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String hintText;
  final Function(String)? onChanged;
  final Function()? onTap;
  final TextEditingController? te;

  const CustomTextField({
    Key? key,
    this.te,
    required this.hintText,
    this.onChanged,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: te,
      onTap: onTap,
      decoration: InputDecoration(
        hintText: hintText,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black26),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black26),
        ),
      ),
      onChanged: onChanged,
    );
  }
}

class PasswordFactor extends StatelessWidget {
  bool satisfied = false;
  String desc = '';

  PasswordFactor({
    Key? key,
    this.satisfied = false,
    required this.desc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 2.5,
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: satisfied ? Colors.blue : Colors.red,
            radius: 10.0,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 9.0,
              child: Icon(
                Icons.check,
                color: satisfied ? Colors.blue : Colors.red,
                size: 12.0,
              ),
            ),
          ),
          const SizedBox(
            width: 10.0,
          ),
          Text(
            desc,
            style: TextStyle(
              color: satisfied ? Colors.blue : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
