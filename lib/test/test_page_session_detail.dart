import 'package:boardwalk/api/api_service.dart';
import 'package:boardwalk/test/test_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TestPageSessionDetail extends StatelessWidget {
  static const id = 'session_detail';

  TestPageSessionDetail({Key? key}) : super(key: key);

  ApiService _apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    TestPageArgs args =
    ModalRoute
        .of(context)!
        .settings
        .arguments as TestPageArgs;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: MaterialButton(
          onPressed: () async {
            List<Map<String, dynamic>> exited = [];
            var curJoined = args.participants.keys.toList();
            var curApproved = args.participants.values.toList();
            for(var i = 0; i < args.participants.length; ++i) {
              if(curJoined[i] == args.curUser) continue;
              Map<String, dynamic> item = {};
              item["key"] = curJoined[i];
              item["value"] = curApproved[i];
              exited.add(item);
            }
            await _apiService.exit(
              args.id,
              exited,
            );
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          Consumer<SessionProvider>(
            builder: (_, session, __) {
              var joined = session.sessionList[session.sessionList
                  .indexWhere((el) => el['id'] == args.id)]['joined'];
              List<String> participants = [];
              for (var e in List.from(joined)) {
                participants.add(e['key']);
              }
              return ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(participants[index]),
                  );
                },
                itemCount: participants.length,
              );
            },
          ),
        ],
      ),
    );
  }
}
