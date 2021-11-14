import 'package:boardwalk/main.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  static const id = 'welcome_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "Welcome to Boardwalk.",
                  style: TextStyle(
                    fontSize: 25.0,
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Text(
                  "Let yourself keep healthy in Boardwalk!",
                ),
              ],
            ),
          ),
          Positioned(
              bottom: 40.0,
              right: 40.0,
              child: InkWell(
                onTap: () {
                  userProvider.clear();
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: const Icon(
                  Icons.arrow_forward,
                  color: Colors.black,
                  size: 40.0,
                ),
              )),
        ],
      ),
    );
  }
}
