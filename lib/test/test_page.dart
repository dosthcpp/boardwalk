import 'dart:convert';

import 'package:boardwalk/auth/auth_service.dart';
import 'package:boardwalk/main.dart' show userProvider;
import 'package:boardwalk/test/test_page_session_detail.dart';
import 'package:flutter/material.dart';
import 'package:boardwalk/api/api_service.dart';
import 'package:flutter/scheduler.dart';
import 'package:boardwalk/api/api_service.dart' show SessionProvider;
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
  String curUser, id;
  List<dynamic> participants = [];

  TestPageArgs({required this.curUser, required this.id, required this.participants});
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
              _apiService.openSession(
                'title',
                'desc',
              );
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
                      final participants = await _apiService.enter(curId,
                          session.sessionList[index]['participants'], curUser);
                      curId = session.sessionList[index]['id'];
                      Navigator.pushNamed(
                        context,
                        TestPageSessionDetail.id,
                        arguments: TestPageArgs(
                          id: curId,
                          participants: participants,
                          curUser: curUser as String,
                        ),
                      );
                    },
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
