import 'dart:convert';

import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:boardwalk/main.dart';
import 'package:flutter/cupertino.dart';

class SessionArgs {
  /*
    * host: String!
  title: String!
  notification: String!
  address: String!
  coordinate: [Float!]!
  event: String!
  startTime: String!
  endTime: String!
  participants: [Int!]!
  joined: [String!]!
  necessarySupplies: [String!]!
  optionalSupplies: [String!]!
  report: Int
    * */
  final String host, title, notification, address, event, startTime, endTime;
  final List<double> coordinate;
  final List<int> participants;
  final List<String> necessarySupplies;
  List<String>? optionalSupplies;

  SessionArgs({
    required this.host,
    required this.title,
    required this.notification,
    required this.address,
    required this.coordinate,
    required this.event,
    required this.startTime,
    required this.endTime,
    required this.participants,
    required this.necessarySupplies,
    this.optionalSupplies,
  });
}

String onJoinedString(list, user) {
  var add = '''[''';
  var li = List.from(list);
  for (var i = 0 ; i < li.length; ++i) {
    var e = li[i];
    add += '''{key: "${e['key']}", value: ${e['value']}}''';
    if(i < li.length - 1) {
      add += ''',''';
    }
  }
  add += ''', {key: "$user", value: false}]''';
  return add;
}

String onExitedString(list) {
  var add = '''[''';
  var li = List.from(list);
  for (var i = 0 ; i < li.length; ++i) {
    var e = li[i];
    add += '''{key: "${e['key']}", value: ${e['value']}}''';
    if(i < li.length - 1) {
      add += ''',''';
    }
  }
  add += ''']''';
  return add;
}

String onApproveString(list, user) {
  var add = '''[''';
  var li = List.from(list);
  for (var i = 0 ; i < li.length; ++i) {
    var e = li[i];
    if(e['key'] == user) {
      add += '''{key: "${e['key']}", value: true}''';
    } else {
      add += '''{key: "${e['key']}", value: ${e['value']}}''';
    }
    if(i < li.length - 1) {
      add += ''', ''';
    }
  }
  add += ''']''';
  return add;
}

class ApiService {
  Future<void> openSession(SessionArgs args) async {
    try {
      String graphQLDocument =
          // ignore: unnecessary_string_escapes
          '''
          mutation CreateSession(
            \$host: String!,
            \$title: String!
            \$notification: String!
            \$address: String!
            \$coordinate: [Float!]!
            \$event: String!
            \$startTime: String!
            \$endTime: String!
            \$participants: [Int!]!
            \$necessarySupplies: [String!]!
            \$optionalSupplies: [String]!
            \$report: Int!
          )
          {
            createSession(input: {
                host: \$host,
                title: \$title,
                notification: \$notification,
                address: \$address,
                coordinate: \$coordinate,
                event: \$event,
                startTime: \$startTime,
                endTime: \$endTime,
                participants: \$participants,
                joined: [{key: "John", value: false}],
                necessarySupplies: \$necessarySupplies,
                optionalSupplies: \$optionalSupplies,
                report: \$report
              }) {
                id
                host
                title
                notification
                address
                coordinate
                event
                startTime
                endTime
                participants
                joined {
                  key
                  value
                }
                necessarySupplies
                optionalSupplies
                report
              }
            }
          ''';
      print(args.address);
      var variables = {
        "host": args.host,
        "title": args.title,
        "notification": args.notification,
        "address": args.address,
        "coordinate": args.coordinate,
        "event": args.event,
        "startTime": args.startTime,
        "endTime": args.endTime,
        "participants": args.participants,
        "necessarySupplies": args.necessarySupplies,
        "optionalSupplies": args.optionalSupplies ?? [],
        "report": 0,
      };
      var request = GraphQLRequest<String>(
        document: graphQLDocument,
        variables: variables,
      );

      var operation = Amplify.API.mutate(request: request);
      var response = await operation.response;

      var data = response.data;
      print(data);
    } on ApiException catch (e) {
      print('Mutation failed: $e');
    } catch (e) {
      print(e);
    }
  }

  Future<String> query() async {
    String graphQLDocument = '''query MyQuery {
      listSessions {
        items {
          id
          host
          title
          notification
          address
          coordinate
          event
          startTime
          endTime
          participants
          joined {
            key
            value
          }
          necessarySupplies
          optionalSupplies
          report
        }
      }
    }''';

    var operation = Amplify.API
        .query<String>(request: GraphQLRequest(document: graphQLDocument));

    var response = await operation.response;
    return response.data;
  }

  Future<void> delete(id) async {
    String graphQLDocument = '''mutation DeleteSession(\$id: ID!) {
          deleteSession(input: { id: \$id }) {
            id
          }
    }''';

    Amplify.API.mutate(
        request: GraphQLRequest<String>(
            document: graphQLDocument, variables: {'id': id}));
  }

  Future<void> join(id, alreadyJoined, user) async {
    try {
      String graphQLDocument = '''
      mutation UpdateSession(\$id: ID!) {
        updateSession(input: {id: \$id, joined: ${onJoinedString(alreadyJoined, user)}}) {
          id
          joined {
            key
            value
          }
        }
      }
      ''';
      print(onJoinedString(alreadyJoined, user));
      Amplify.API.mutate(
        request: GraphQLRequest<String>(
          document: graphQLDocument,
          variables: {
            'id': id,
          },
        ),
      );
    } on ApiException catch (e) {
      print('Mutation failed: $e');
    } catch(e) {
      print(e);
    }

    // Map<String, bool> participants = {};
    // for (var e in List.from(alreadyJoined)) {
    //   participants[e['key']] = e['value'];
    // }
    // participants[user] = false;
    //
    // return participants;
    // return [];
  }

  Future<List<GraphQLResponseError>?> approve(id, alreadyJoined, user) async {
    try {
      String graphQLDocument = '''
      mutation UpdateSession(\$id: ID!) {
        updateSession(input: {id: \$id, joined: ${onApproveString(alreadyJoined, user)}}) {
          id
          joined {
            key
            value
          }
        }
      }
      ''';
      var res = Amplify.API.mutate(
        request: GraphQLRequest<String>(
          document: graphQLDocument,
          variables: {
            'id': id,
          },
        ),
      );
      return (await res.response).errors;
    } on ApiException catch (e) {
      print('Mutation failed: $e');
    } catch(e) {
      print(e);
    }

    // Map<String, bool> participants = {};
    // for (var e in List.from(alreadyJoined)) {
    //   participants[e['key']] = e['value'];
    // }
    // participants[user] = false;
    //
    // return participants;
    // return [];
  }

  Future<void> exit(id, List<Map<String, dynamic>> exited) async {
    try {
      print(onExitedString(exited));
      String graphQLDocument = '''
      mutation UpdateSession(\$id: ID!) {
        updateSession(input: {id: \$id, joined: ${onExitedString(exited)}}) {
          id
          joined {
            key
            value
          }
        }
      }
      ''';
      var res = Amplify.API.mutate(
        request: GraphQLRequest<String>(
          document: graphQLDocument,
          variables: {
            'id': id,
          },
        ),
      );
      print((await res.response).data);
    } on ApiException catch (e) {
      print('Mutation failed: $e');
    }
  }

  Future<Function> onCreateSubscribe(Function callback) async {
    late var operation;
    try {
      String _onCreate = '''
      subscription createSub {
        onCreateSession {
          id
          host
          title
          notification
          address
          coordinate
          event
          startTime
          endTime
          participants
          joined {
            key
            value
          }
          necessarySupplies
          optionalSupplies
          report
        }
      }''';

      operation = Amplify.API.subscribe(
          request: GraphQLRequest<String>(document: _onCreate),
          onData: (event) async {
            callback(event.data);
          },
          onEstablished: () {
            print('Subscription established');
          },
          onError: (dynamic e) {
            print('Error occurred');
            print(e);
          },
          onDone: () {
            print('Subscription has been closed successfully');
          });
    } on ApiException catch (e) {
      print('Subscription failed: $e');
    }

    void unsubscribe() {
      operation.cancel();
    }

    return unsubscribe;
  }

  Future<Function> onEnter(Function callback) async {
    late var operation;
    try {
      String _onUpdate = '''
      subscription MySubscription {
        onUpdateSession {
          joined {
            key
            value
          }
          id
        }
      }
      ''';

      operation = Amplify.API.subscribe(
        request: GraphQLRequest<String>(
          document: _onUpdate,
        ),
        onData: (event) async {
          final updated = jsonDecode(event.data as String)['onUpdateSession'];
          callback(updated);
        },
        onEstablished: () {
          print('Subscription established');
        },
        onError: (dynamic e) {
          print('Error occurred');
          print(e);
        },
        onDone: () {
          print('Subscription has been closed successfully');
        },
      );
    } on ApiException catch (e) {
      print('Subscription failed: $e');
    } catch (e, stacktrace) {
      print(stacktrace);
    }

    void unsubscribe() {
      operation.cancel();
    }

    return unsubscribe;
  }

  Future<Function> onDeleteSubscribe(Function callback) async {
    late var operation;
    try {
      String _onDelete = '''subscription deleteSub {
        onDeleteSession {
          id
        }
      }''';
      operation = Amplify.API.subscribe(
          request: GraphQLRequest<String>(document: _onDelete),
          onData: (event) async {
            callback(event.data);
          },
          onEstablished: () {
            print('Subscription established');
          },
          onError: (dynamic e) {
            print('Error occurred');
            print(e);
          },
          onDone: () {
            print('Subscription has been closed successfully');
          });
    } on ApiException catch (e) {
      print('Subscription failed: $e');
    }

    void unsubscribe() {
      operation.cancel();
    }

    return unsubscribe;
  }

// getSession() async {
//   try {
//     String graphQLDocument =
//     '''mutation CreateSession(\$title: String!, \$description: String, \$participants: [String!]!) {
//             createSession(input: {title: \$title, description: \$description, participants: \$participants}) {
//               id
//               title
//               description
//               participants
//             }
//       }''';
//     var variables = {
//       "title": title,
//       "description": description,
//       "participants": [],
//     };
//     var request = GraphQLRequest<String>(
//       document: graphQLDocument,
//       variables: variables,
//     );
//
//     var operation = Amplify.API.mutate(request: request);
//     var response = await operation.response;
//
//     var data = response.data;
//
//     print('Mutation result: ' + data);
//   } on ApiException catch (e) {
//     print('Mutation failed: $e');
//   }
// }
}

class SessionProvider with ChangeNotifier {
  List<dynamic> sessionList = [];
  late Function unSubOnCreate, unSubOnDelete, unSubOnUpdate;
  late VoidCallback cb;
  final ApiService _apiService = ApiService();

  init() async {
    try {
      unSubOnCreate = await _apiService.onCreateSubscribe(
        (String data) async {
          var newSession = jsonDecode(data)['onCreateSession'];
          sessionList.add({...newSession, 'checked': false});

          notifyListeners();
        },
      );
      unSubOnUpdate = await _apiService.onEnter(
        (updated) async {
          sessionList[sessionList.indexWhere((el) => el['id'] == updated['id'])]
              ['joined'] = updated['joined'];

          notifyListeners();
        },
      );
      unSubOnDelete = await _apiService.onDeleteSubscribe(
        (String data) async {
          final _id = jsonDecode(data)['onDeleteSession']['id'];
          print(_id);
          sessionList.removeWhere((el) => el['id'] == _id);
          notifyListeners();
        },
      );
      sessionList =
          jsonDecode(await _apiService.query())['listSessions']['items'];
      for (var session in sessionList) {
        session['checked'] = false;
      }
      notifyListeners();
    } catch (e) {
      // print('not working');
      print(e);
    }
  }

  unsubscribe() {
    try {
      unSubOnCreate();
      unSubOnDelete();
      unSubOnUpdate();
    } catch (e) {
      print(e);
    }
  }

  check(i) {
    sessionList[i]['checked'] = !sessionList[i]['checked'];
    notifyListeners();
  }
}
