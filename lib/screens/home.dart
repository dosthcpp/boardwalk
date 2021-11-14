import 'package:boardwalk/auth/auth_service.dart';
import 'package:boardwalk/screens/create_spot.dart';
import 'package:intl/intl.dart' as intl;
import 'package:boardwalk/main.dart' show sessionProvider, googleSignIn;

import 'package:boardwalk/main.dart' show userProvider;
import 'package:boardwalk/screens/detail.dart';
import 'package:boardwalk/screens/review.dart';
import 'package:boardwalk/screens/profile_and_settings.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  static const id = 'home';

  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final _authService = AuthService();

  @override
  void initState() {
    super.initState();
    sessionProvider.init();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _scaffoldKey,
        endDrawer: Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              const SizedBox(
                height: 50.0,
              ),
              ListTile(
                title: const Text('Write a review'),
                onTap: () {
                  Navigator.pushNamed(context, Review.id);
                },
              ),
              ListTile(
                title: const Text('Profile and settings'),
                onTap: () {
                  Navigator.pushNamed(context, ProfileAndSettings.id);
                },
              ),
              ListTile(
                title: const Text('Sign Out'),
                onTap: () async {
                  _authService.signOut();
                  if(googleSignIn.currentUser != null) {
                    await googleSignIn.signOut();
                  }
                  userProvider.clear();
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              ),
            ],
          ),
        ),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(
            70.0,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
            ),
            child: AppBar(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              leading: null,
              automaticallyImplyLeading: false,
              title: Transform(
                transform: Matrix4.translationValues(-80.0, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Good morning,",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: MediaQuery.of(context).size.width * 0.063,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      userProvider.getNickname(),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: MediaQuery.of(context).size.width * 0.055,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                Transform(
                  transform: Matrix4.translationValues(0, -10.0, 0),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 10.0,
                      ),
                      Container(
                        width: 25.0,
                        height: 25.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: Image.asset(
                              'assets/bell-ring.png',
                            ).image,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      InkWell(
                        onTap: () {
                          if (!_scaffoldKey.currentState!.isDrawerOpen) {
                            _scaffoldKey.currentState!.openEndDrawer();
                          }
                        },
                        child: Container(
                          width: 25.0,
                          height: 25.0,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: Image.asset(
                                'assets/menu.png',
                              ).image,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 40.0,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Highlights of This week",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Container(
                  clipBehavior: Clip.none,
                  height: 120.0,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 3.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      5.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 4,
                        child: IntrinsicHeight(
                          child: Row(
                            children: [
                              Flexible(
                                child: HighlightPanel(
                                  number: 3821,
                                  f: intl.NumberFormat('###,###,###,###'),
                                  title: "Steps",
                                  filePath: 'assets/footsteps.png',
                                ),
                              ),
                              const SizedBox(
                                height: 80.0,
                                child: VerticalDivider(
                                  thickness: 2.0,
                                ),
                              ),
                              Flexible(
                                child: HighlightPanel(
                                  number: 3.1,
                                  f: intl.NumberFormat('#,###.0#'),
                                  unit: "Mi",
                                  title: "Running\nDistance",
                                  filePath: 'assets/run.png',
                                ),
                              ),
                              const SizedBox(
                                height: 80.0,
                                child: VerticalDivider(
                                  thickness: 2.0,
                                ),
                              ),
                              Flexible(
                                child: HighlightPanel(
                                  number: 7,
                                  f: intl.NumberFormat('#,###'),
                                  unit: "Times",
                                  title: "Joined\nspots",
                                  filePath: 'assets/flame.png',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Container(
                  height: 130.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        5.0,
                      ),
                      image: const DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage(
                          'assets/ad_placeholder.png',
                        ),
                      )),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Find Spots in Oakwood",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                      ),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Row(
                      children: [
                        MaterialButton(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5.0,
                          ),
                          minWidth: 0,
                          onPressed: () {
                            Navigator.pushNamed(context, CreateSpot.id);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black54,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(
                                5.0,
                              ),
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        MaterialButton(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5.0,
                          ),
                          minWidth: 0,
                          onPressed: () {},
                          child: const Icon(
                            Icons.search,
                            color: Colors.black54,
                          ),
                        ),
                        MaterialButton(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5.0,
                          ),
                          minWidth: 0,
                          onPressed: () {},
                          child: Image.asset(
                            'assets/volume-bars.png',
                            scale: 10.0,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 10.0,
                ),
                const Spots(
                  title: 'Let\'s jog in Alberta Banks',
                ),
                const SizedBox(
                  height: 10.0,
                ),
                const Spots(title: 'Let\'s badminton in park'),
                const SizedBox(
                  height: 10.0,
                ),
                const Spots(title: 'Let\'s badminton in park'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HighlightPanel extends StatelessWidget {
  final intl.NumberFormat f;

  final double number;
  final String unit, title, filePath;

  HighlightPanel({
    Key? key,
    required this.f,
    required this.number,
    this.unit = '',
    required this.title,
    required this.filePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: f.format(number).toString(),
                style: const TextStyle(
                  fontSize: 27.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1.5,
                ),
              ),
              WidgetSpan(
                child: Transform.translate(
                  offset: const Offset(5, -8),
                  child: Text(
                    unit,
                    style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              filePath,
              scale: 20.0,
              color: Colors.black54,
            ),
            const SizedBox(
              width: 8.0,
            ),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12.0,
              ),
            )
          ],
        )
      ],
    );
  }
}

class Information extends StatelessWidget {
  final String imageUrl, description;
  final double textSize, imageScale;
  final Color textColor, imageColor;
  final bool bold;

  const Information({
    Key? key,
    this.textSize = 10.0,
    this.textColor = Colors.black,
    this.imageColor = Colors.black,
    this.imageScale = 22.0,
    this.bold = true,
    required this.imageUrl,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          imageUrl,
          color: imageColor,
          scale: imageScale,
        ),
        const SizedBox(
          width: 10.0,
        ),
        Text(
          description,
          style: TextStyle(
            fontSize: textSize,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            color: textColor,
          ),
        ),
      ],
    );
  }
}

class Spots extends StatelessWidget {
  final String title;

  const Spots({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      onPressed: () {
        Navigator.pushNamed(context, Detail.id);
      },
      padding: EdgeInsets.zero,
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 3.0,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            10.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              height: 140,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
                image: DecorationImage(
                  alignment: Alignment(
                    0,
                    -0.9,
                  ),
                  fit: BoxFit.fitWidth,
                  image: AssetImage(
                    'assets/jogging.jpeg',
                  ),
                ),
              ),
            ),
            Container(
              height: 150.0,
              decoration: const BoxDecoration(
                  borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0),
              )),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 15.0,
                    ),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    Row(
                      children: [
                        Flexible(
                          flex: 7,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Information(
                                imageUrl: 'assets/shoes.png',
                                description: 'Jogging, 1.2Mi~2.17Mi',
                                textSize: MediaQuery.of(context).size.width * 0.023,
                                textColor: Colors.black54,
                                imageColor: Colors.black54,
                              ),
                              const SizedBox(
                                height: 5.0,
                              ),
                              Information(
                                imageUrl: 'assets/pin.png',
                                description: 'Alberta Banks Park, Oak...',
                                textSize: MediaQuery.of(context).size.width * 0.023,
                                textColor: Colors.black54,
                                imageColor: Colors.black54,
                              ),
                              const SizedBox(
                                height: 5.0,
                              ),
                              Information(
                                imageUrl: 'assets/clock.png',
                                description: '21.10.11(Sun) 6AM~8:30AM',
                                textSize: MediaQuery.of(context).size.width * 0.023,
                                textColor: Colors.black54,
                                imageColor: Colors.black54,
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          flex: 5,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Information(
                                imageUrl: 'assets/user.png',
                                description: 'Luka, General Host',
                                textSize: MediaQuery.of(context).size.width * 0.023,
                                textColor: Colors.black54,
                                imageColor: Colors.black54,
                              ),
                              const SizedBox(
                                height: 5.0,
                              ),
                              Information(
                                imageUrl: 'assets/person.png',
                                description: '2~5 People',
                                textSize: MediaQuery.of(context).size.width * 0.023,
                                textColor: Colors.black54,
                                imageColor: Colors.black54,
                              ),
                              const SizedBox(
                                height: 5.0,
                              ),
                              const SizedBox(
                                height: 22.0,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
