import 'package:boardwalk/auth/auth_service.dart';
import 'package:flutter/material.dart';

class ExceptionPage extends StatelessWidget {
  static const id = 'exception_page';
  final _authService = AuthService();

  ExceptionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(
            child: Text(
              "Unknown Exception! Please tap button below.",
            ),
          ),
          const SizedBox(
            height: 10.0,
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
                "Resolve",
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
              onPressed: () async {
                await _authService.signOut(true);
                Navigator.pop(context);
                // Navigator.popUntil(context, (route) => route.isFirst);
              },
            ),
          ),
        ],
      ),
    );
  }
}
