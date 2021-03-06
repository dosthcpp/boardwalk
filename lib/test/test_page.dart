import 'dart:convert';

import 'package:boardwalk/auth/auth_service.dart';
import 'package:boardwalk/main.dart' show userProvider;
import 'package:boardwalk/test/test_page_session_detail.dart';
import 'package:flutter/material.dart';
import 'package:boardwalk/api/api_service.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:boardwalk/main.dart' show sessionProvider;

class TestPage extends StatefulWidget {
  static const id = 'test_page';

  TestPage({
    Key? key,
  }) : super(key: key);

  @override
  State<TestPage> createState() => _TestPageState();
}

class TestPageArgs {
  String curUser, id, title, description;
  Map<String, bool> participants = {};

  TestPageArgs({
    required this.curUser,
    required this.id,
    required this.title,
    required this.description,
    required this.participants,
  });
}

class _TestPageState extends State<TestPage> {
  // late final StreamController<List<String>> sessionController;
  // late DataService _dataService;
  final ApiService _apiService = ApiService();
  final _authService = AuthService();
  String curId = '';

  @override
  void initState() {
    super.initState();
    // _dataService = DataService();
    // _dataService.getImages();
    // sessionController = _dataService.sessionController;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {
              // _apiService.openSession(
              //   'title',
              //   'desc',
              // );
            },
            child: const Text(
              '세션 추가',
              style: TextStyle(
                color: Colors.black54,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              _apiService.delete(curId);
            },
            child: const Text(
              '세션 삭제',
              style: TextStyle(
                color: Colors.black54,
              ),
            ),
          ),
          // TextButton(
          //   onPressed: () {
          //   },
          //   child: const Text(
          //     '테스트',
          //     style: TextStyle(
          //       color: Colors.black54,
          //     ),
          //   ),
          // )
        ],
      ),
      body: FutureBuilder(
        future: _authService.getNickname(),
        builder: (context, snapshot) {
          final curUser = snapshot.data;
          return Consumer<SessionProvider>(
            builder: (_, session, __) {
              return ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      session.sessionList[index]['title'],
                    ),
                    onTap: () async {
                      // var _sessionInfo = session.sessionList[index];
                      // final participants = await _apiService.join(
                      //   _sessionInfo['id'],
                      //   _sessionInfo['joined'],
                      //   curUser,
                      // );
                      // Navigator.pushNamed(
                      //   context,
                      //   TestPageSessionDetail.id,
                      //   arguments: TestPageArgs(
                      //     id: _sessionInfo['id'],
                      //     title: _sessionInfo['title'],
                      //     description: _sessionInfo['notification'],
                      //     participants: participants,
                      //     curUser: curUser as String,
                      //   ),
                      // );
                    },
                    trailing: Checkbox(
                      value: session.sessionList[index]['checked'],
                      onChanged: (value) {
                        setState(() {
                          session.check(index);
                          curId = session.sessionList[index]['id'];
                        });
                      },
                    ),
                  );
                },
                itemCount: session.sessionList.length,
              );
            },
          );
        },
      ),
    );
  }
}
