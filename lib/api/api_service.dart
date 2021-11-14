import 'dart:convert';

import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:flutter/cupertino.dart';

class ApiService {
  openSession(title, description) async {
    try {
      String graphQLDocument =
          '''mutation CreateSession(\$title: String!, \$description: String, \$participants: [String!]!) {
              createSession(input: {title: \$title, description: \$description, participants: \$participants}) {
                id
                title
                description
                participants
              }
        }''';
      var variables = {
        "title": title,
        "description": description,
        "participants": [],
      };
      var request = GraphQLRequest<String>(
        document: graphQLDocument,
        variables: variables,
      );

      var operation = Amplify.API.mutate(request: request);
      var response = await operation.response;

      var data = response.data;
    } on ApiException catch (e) {
      print('Mutation failed: $e');
    }
  }

  Future<String> query() async {
    String graphQLDocument = '''query MyQuery {
      listSessions {
        items {
          id
          title
          description
          participants
        }
      }
    }''';

    var operation = Amplify.API
        .query<String>(request: GraphQLRequest(document: graphQLDocument));

    var response = await operation.response;
    return response.data;
  }

  Future<void> delete(id) async {
    String graphQLDocument = '''mutation deleteSession(\$id: ID!) {
          deleteSession(input: { id: \$id }) {
            id
          }
    }''';

    var operation = Amplify.API.mutate(
        request: GraphQLRequest<String>(
            document: graphQLDocument, variables: {'id': id}));
  }

  Future<List<String>> enter(id, participants, user) async {
    String graphQLDocument =
        // 버그인듯
        '''mutation UpdateSession(\$id: ID!, \$participants: [String!]) {
          updateSession(input: { id: \$id, participants: \$participants}) {
            participants
          }
    }''';

    var operation = Amplify.API.mutate(
        request: GraphQLRequest<String>(document: graphQLDocument, variables: {
      'id': id,
      'participants': [...participants, user],
    }));
    return [...participants, user];
  }

  Future<void> exit(id, participants) async {
    String graphQLDocument =
        '''mutation UpdateSession(\$id: ID!, \$participants: [String!]) {
          updateSession(input: { id: \$id, participants: \$participants}) {
            participants
          }
    }''';

    var operation = Amplify.API.mutate(
        request: GraphQLRequest<String>(document: graphQLDocument, variables: {
      'id': id,
      'participants': participants,
    }));
  }

  Future<Function> onCreateSubscribe(Function callback) async {
    late var operation;
    try {
      String _onCreate = '''subscription createSub {
        onCreateSession {
          id
          title
          description
          participants
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

  Future<Function> onUpdateSubscribe(Function callback) async {
    late var operation;
    try {
      String _onUpdate = '''subscription updateSub {
        onUpdateSession {
          id
          title
          description
          participants
        }
      }''';

      operation = Amplify.API.subscribe(
          request: GraphQLRequest<String>(document: _onUpdate),
          onData: (event) async {
            print(event.data);
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
    unSubOnCreate = await _apiService.onCreateSubscribe(
      (String data) async {
        sessionList.add(jsonDecode(data)['onCreateSession']);
        notifyListeners();
      },
    );
    unSubOnUpdate = await _apiService.onUpdateSubscribe(
      (String data) async {
        print(data);
        // final updated = jsonDecode(data);
        // print('updated' + updated);
        // sessionList.removeWhere((el) => el['id'] == _id);
        // notifyListeners();
      },
    );
    unSubOnDelete = await _apiService.onDeleteSubscribe(
      (String data) async {
        final _id = jsonDecode(data)['onDeleteSession']['id'];
        sessionList.removeWhere((el) => el['id'] == _id);
        notifyListeners();
      },
    );
    sessionList =
        jsonDecode(await _apiService.query())['listSessions']['items'];
    notifyListeners();
  }
}
