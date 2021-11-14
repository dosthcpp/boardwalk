import 'package:boardwalk/api/api_service.dart';
import 'package:boardwalk/test/test_page.dart';
import 'package:flutter/material.dart';

class TestPageSessionDetail extends StatelessWidget {
  static const id = 'session_detail';

  TestPageSessionDetail({Key? key}) : super(key: key);

  ApiService _apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    TestPageArgs args =
        ModalRoute.of(context)!.settings.arguments as TestPageArgs;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: MaterialButton(
          onPressed: () async {
            List<String> exited = args.participants as List<String>;
            exited.removeWhere((el) => el == args.curUser);
            await _apiService.exit(args.id, exited);
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(),
    );
  }
}
