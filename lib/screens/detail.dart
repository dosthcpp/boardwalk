import 'package:boardwalk/main.dart';
import 'package:boardwalk/screens/home.dart' show Information;
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class Detail extends StatefulWidget {
  static const id = 'detail';

  const Detail({Key? key}) : super(key: key);

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      // if (states.any(interactiveStates.contains)) {
      //   return Colors.blue;
      // }
      return Colors.blue;
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
          ),
          child: Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 1.0,
                  color: Colors.black54,
                ),
              ),
            ),
            child: AppBar(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              automaticallyImplyLeading: false,
              leading: Transform(
                transform: Matrix4.translationValues(-15.0, 0, 0),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Center(
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.black54,
                      size: 35.0,
                    ),
                  ),
                ),
              ),
              actions: [
                InkWell(
                  onTap: () {},
                  child: const Icon(
                    Icons.share,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                SizedBox(
                  width: 20.0,
                  child: InkWell(
                    onTap: () {},
                    child: Image.asset(
                      'assets/more.png',
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30.0,
              ),
              Container(
                height: 150,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
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
              const SizedBox(
                height: 20.0,
              ),
              const Text(
                "Let\'s jog in Alberta Banks",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              const Information(
                textSize: 13.5,
                imageUrl: 'assets/shoes.png',
                description: 'Jogging, 1.2Mi~2.17Mi',
                bold: false,
              ),
              const SizedBox(
                height: 10.0,
              ),
              const Information(
                textSize: 13.5,
                imageUrl: 'assets/pin.png',
                description: 'Alberta Banks Park,\nOakwood, Georgia',
                bold: false,
              ),
              const SizedBox(
                height: 10.0,
              ),
              const Information(
                textSize: 13.5,
                imageUrl: 'assets/person.png',
                description: '2~5 People',
                bold: false,
              ),
              const SizedBox(
                height: 10.0,
              ),
              const Information(
                textSize: 13.5,
                imageUrl: 'assets/clock.png',
                description: '10.11.21(Sun) 6AM ~ 8:30AM',
                bold: false,
              ),
              const SizedBox(
                height: 10.0,
              ),
              const Information(
                  textSize: 13.5,
                  textColor: Colors.redAccent,
                  imageColor: Colors.redAccent,
                  imageUrl: 'assets/megaphone.png',
                  description: 'Fully Vaccinated participant ONLY.',
                  bold: false),
              const Divider(
                color: Colors.black54,
                thickness: 1.0,
                height: 20.0,
              ),
              const SizedBox(
                height: 10.0,
              ),
              const Text(
                "Necessary supplies",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              const Supply(
                text: 'Running shoes',
              ),
              const SizedBox(
                height: 20.0,
              ),
              const Text(
                "Optional supplies",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Row(
                children: const [
                  Supply(
                    text: 'Training outfit',
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Supply(
                    text: 'Personal drink',
                  ),
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),
              const Text(
                "Notification from the host",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              const Center(
                child: Text(
                  "Please prepare your own running shoes and be punctual!",
                ),
              ),
              const Divider(
                height: 40.0,
                color: Colors.black54,
                thickness: 1.0,
              ),
              const Text(
                "Host Info",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),
              Profile(),
              const Divider(
                height: 40.0,
                thickness: 1.0,
                color: Colors.black54,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Main event",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    "Running",
                  ),
                ],
              ),
              const SizedBox(
                height: 20.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Workout Cycle",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    "Once a week in average",
                  ),
                ],
              ),
              const SizedBox(
                height: 20.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Self introduction",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    "Run once a week and make your life healthy!",
                  ),
                ],
              ),
              Container(
                height: 250.0,
              )
            ],
          ),
        ),
      ),
      bottomSheet: CustomScrollView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                    ),
                    child: Column(
                      children: [
                        const Divider(
                          height: 20.0,
                          color: Colors.black54,
                          thickness: 1.0,
                        ),
                        Transform(
                          transform: Matrix4.translationValues(-20.0, 0.0, 0.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Transform(
                                transform:
                                    Matrix4.translationValues(0.0, -15.0, 0.0),
                                child: Checkbox(
                                  checkColor: Colors.white,
                                  fillColor: MaterialStateProperty.resolveWith(
                                      getColor),
                                  value: isChecked,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      isChecked = value!;
                                    });
                                  },
                                ),
                              ),
                              const Flexible(
                                child: Text(
                                  'I have checked the necessary supplies, and I agree to the terms and conditions of participation in the session andpersonal information.',
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: MaterialButton(
                            onPressed: () {
                              if (isChecked) {
                                AwesomeDialog(
                                  context: context,
                                  animType: AnimType.SCALE,
                                  dialogType: DialogType.SUCCES,
                                  btnOk: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.indigo,
                                    ),
                                    child: const Text(
                                      'Confirm',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  body: const Center(
                                    child: Text(
                                      'Your request has been sent to Sangjun. The host will let you know if he/she approve or not.',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  btnOkOnPress: () {},
                                ).show();
                              } else {
                                AwesomeDialog(
                                  context: context,
                                  animType: AnimType.SCALE,
                                  dialogType: DialogType.ERROR,
                                  btnOk: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.indigo,
                                    ),
                                    child: const Text(
                                      'Confirm',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  body: const Center(
                                    child: Text(
                                      'Your request was not sent to Sangjun.\nReason: Terms and conditions not checked.',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  btnOkOnPress: () {},
                                ).show();
                              }
                            },
                            color: Colors.indigo,
                            child: const Text(
                              "Request join to Spot",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ]),
    );
  }
}

class Supply extends StatelessWidget {
  final String text;

  const Supply({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          height: 40.0,
          child: VerticalDivider(
            color: Colors.black54,
            thickness: 4.0,
            width: 10.0,
          ),
        ),
        const SizedBox(
          width: 10.0,
        ),
        Text(
          text,
        )
      ],
    );
  }
}

class Profile extends StatelessWidget {
  String buttonTitle;

  Profile({Key? key, this.buttonTitle = 'Follow'}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15.0,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    child: Image.asset(
                      'assets/user.png',
                      color: Colors.black54,
                      scale: 30.0,
                    ),
                    backgroundColor: Colors.black12,
                    radius: 35.0,
                  ),
                  const SizedBox(
                    width: 30.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: userProvider.getNickname(),
                              style: TextStyle(
                                fontSize: userProvider.getNickname().length > 5 ? 13.0 : 25.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            WidgetSpan(
                              child: Transform.translate(
                                offset: const Offset(8, 0),
                                child: const Text(
                                  'male',
                                  textScaleFactor: 1.0,
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 2.0,
                      ),
                      const Text(
                        "General Host",
                        style: TextStyle(
                          fontSize: 12.0,
                        ),
                      ),
                      const SizedBox(
                        height: 3.0,
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: "User Rating",
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.black,
                              ),
                            ),
                            WidgetSpan(
                              child: Transform.translate(
                                offset: const Offset(5, -1),
                                child: const Text(
                                  'Good',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 12.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                  right: 10.0,
                ),
                child: SizedBox(
                  width: 70.0,
                  child: MaterialButton(
                    onPressed: () {},
                    color: Colors.indigo,
                    child: Text(
                      buttonTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 15.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Information(
                imageUrl: 'assets/pin.png',
                description: 'In Oakwood',
                textSize: 12.0,
                bold: false,
              ),
              SizedBox(
                width: 5.0,
              ),
              Information(
                imageUrl: 'assets/inject.png',
                description: 'Fully Vaccinated',
                imageColor: Color(0xff51ab9f),
                textSize: 12.0,
                imageScale: 6.0,
                bold: false,
              ),
            ],
          ),
          const SizedBox(
            height: 10.0,
          ),
          const Information(
            imageUrl: 'assets/secure.png',
            description: 'User Certified',
            imageColor: Color(0xff4587d3),
            textSize: 12.0,
            imageScale: 6.0,
            bold: false,
          ),
          const SizedBox(
            height: 15.0,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              Badge(number: 5, title: "Hosted\nSpots"),
              Badge(number: 5, title: "Joined\nSpots"),
              Badge(number: 5, title: "Follower"),
              Badge(number: 5, title: "Following"),
            ],
          ),
        ],
      ),
    );
  }
}

class Badge extends StatelessWidget {
  final int number;
  final String title;

  const Badge({
    Key? key,
    required this.number,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            number.toString(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 23.0,
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              letterSpacing: -1.0,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
