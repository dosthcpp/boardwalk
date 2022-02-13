import 'package:boardwalk/main.dart';
import 'package:flutter/material.dart';
import 'package:boardwalk/screens/detail.dart' show Profile;

class ProfileAndSettings extends StatelessWidget {
  static const id = 'profile_and_settings';

  const ProfileAndSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: MaterialButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.close,
            color: Colors.black,
            size: 30.0,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Profile",
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(
              thickness: 1.0,
              color: Colors.black54,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 5.0,
              ),
              child: Profile(
                hostName: userProvider.getNickname(),
                buttonTitle: 'Edit',
              ),
            ),
            const Divider(
              thickness: 1.0,
              color: Colors.black54,
            ),
            const SizedBox(
              height: 10.0,
            ),
            Row(
              children: const [
                Icon(
                  Icons.settings,
                  color: Colors.black54,
                  size: 50.0,
                ),
                SizedBox(
                  width: 5.0,
                ),
                Text(
                  "Settings",
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10.0,
            ),
            Row(
              children: const [
                Icon(
                  Icons.masks,
                  color: Colors.black54,
                  size: 50.0,
                ),
                SizedBox(
                  width: 5.0,
                ),
                Text(
                  "COVID-19 Information Center",
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
