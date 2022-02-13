import 'package:flutter/material.dart';

class ForgotPassword extends StatelessWidget {
  static const id = 'forgot_password';

  const ForgotPassword({Key? key}) : super(key: key);

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
                  "Reset Password",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4,
                ),
                Stack(
                  children: [
                    const Positioned(
                      top: 15.0,
                      child: Text(
                        'Email',
                      ),
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(
                          left: 70.0,
                        ),
                        hintText: "Required",
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black26),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black26),
                        ),
                      ),
                      onChanged: (email) {},
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Center(
                  child: SizedBox(
                    height: 50.0,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Material(
                      shape: const RoundedRectangleBorder(
                        side: BorderSide(
                          color: Colors.redAccent,
                        ),
                      ),
                      child: MaterialButton(
                        disabledColor: Colors.grey,
                        child: const Text(
                          "Reset Password",
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 20.0,
                          ),
                        ),
                        onPressed: () async {},
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Need help?",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    Text(
                      "Please send email to contact@boardwalk.team and we will help you as soon as possible.",
                      style: TextStyle(
                        fontSize: 17.0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 50.0,
                ),
                Center(
                  child: SizedBox(
                    height: 50.0,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: MaterialButton(
                      disabledColor: Colors.grey,
                      color: Colors.blueAccent,
                      child: const Text(
                        "Back to Sign in",
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                      onPressed: () async {

                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
