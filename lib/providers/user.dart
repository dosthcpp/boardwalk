import 'package:flutter/material.dart';

import 'package:google_sign_in/google_sign_in.dart';

class UserProvider with ChangeNotifier {
  GoogleSignInAccount? _currentUser;
  String _email = '';
  String _name = '';
  String _nickname = '';

  void setCurrentUser(user) {
    _currentUser = user;
    if(user != null) {
      _email = _currentUser!.email;
    }
    notifyListeners();
  }

  GoogleSignInAccount? getCurrentUser() {
    return _currentUser;
  }

  void setEmail(email) {
    _email = email;
    notifyListeners();
  }

  String getEmail() {
    return _email;
  }

  void setName(name) {
    _name = name;
    notifyListeners();
  }

  String getName() {
    return _name;
  }

  void setNickname(nickname) {
    _nickname = nickname;
    notifyListeners();
  }

  String getNickname() {
    return _nickname;
  }

  // Future<void> handleGetContact() async {
  //   _address = "Loading address info...";
  //
  //   final http.Response response = await http.get(
  //     Uri.parse('https://people.googleapis.com/v1/people/me/'
  //         '?personFields=addresses'),
  //     headers: await _currentUser?.authHeaders,
  //   );
  //   if (response.statusCode != 200) {
  //     _address = "People API gave a ${response.statusCode} "
  //         "response. Check logs for details.";
  //
  //     print('People API ${response.statusCode} response: ${response.body}');
  //     return;
  //   }
  //   final Map<String, dynamic> data = json.decode(response.body);
  //   print(data);
  //   // TODO: parse address info
  //   // final String? namedContact = _parseAddresses(data);
  //   // setState(() {
  //   //   if (namedContact != null) {
  //   //     _address = "I see you know $namedContact!";
  //   //   } else {
  //   //     _address = "No contacts to display.";
  //   //   }
  //   // });
  // }

  String? _parseAddresses(Map<String, dynamic> data) {
    // final List<dynamic>? connections = data['connections'];
    // final Map<String, dynamic>? contact = connections?.firstWhere(
    //       (dynamic contact) => contact['names'] != null,
    //   orElse: () => null,
    // );
    // if (contact != null) {
    //   final Map<String, dynamic>? name = contact['names'].firstWhere(
    //         (dynamic name) => name['displayName'] != null,
    //     orElse: () => null,
    //   );
    //   if (name != null) {
    //     return name['displayName'];
    //   }
    // }
    // return null;
  }

  clear() {
    _currentUser = null;
    // _address = '';
    _email = '';
    _nickname = '';
    notifyListeners();
  }
}
