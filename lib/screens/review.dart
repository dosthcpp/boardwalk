import 'dart:async';
import 'package:boardwalk/screens/detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Review extends StatefulWidget {
  static const id = 'review';

  const Review({Key? key}) : super(key: key);

  @override
  State<Review> createState() => _ReviewState();
}

class _ReviewState extends State<Review> {
  late double _rating;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _rating = 3.0;
  }

  @override
  Widget build(BuildContext context) {
    ReviewArgs args = ModalRoute.of(context)!.settings.arguments as ReviewArgs;

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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            Center(
              child: CircleAvatar(
                child: Image.asset(
                  'assets/user.png',
                  color: Colors.black54,
                  scale: 15.0,
                ),
                backgroundColor: Colors.black12,
                radius: 50.0,
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Text(
              "What did you think of the ${args.host}'s spot?",
              style: TextStyle(
                fontSize: 17.0,
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            RatingBar.builder(
              initialRating: 3.0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              unratedColor: Colors.grey.withAlpha(50),
              itemCount: 5,
              itemSize: 40.0,
              itemPadding: const EdgeInsets.symmetric(
                horizontal: 4.0,
              ),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.blue,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  _rating = rating;
                });
              },
              updateOnDrag: true,
            ),
            const SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 50.0,
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20.0,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.indigo.withAlpha(50),
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(
                          2.0,
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 5.0,
                        ),
                        child: Text(
                          "Conversation",
                          style: TextStyle(
                            color: Colors.indigo,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.indigo.withAlpha(50),
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(
                          2.0,
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 5.0,
                        ),
                        child: Text(
                          "Only necessary mention",
                          style: TextStyle(
                            color: Colors.indigo,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.indigo.withAlpha(50),
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(
                          2.0,
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 5.0,
                        ),
                        child: Text(
                          "Conversation",
                          style: TextStyle(
                            color: Colors.indigo,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.08,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              child: Card(
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    color: Colors.black54,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(
                    4.0,
                  ),
                ),
                shadowColor: Colors.transparent,
                child: const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 10.0,
                  ),
                  child: TextField(
                    maxLines: 8,
                    decoration: InputDecoration.collapsed(
                        hintText:
                            "Please leave a honest feedback for additional improvement.",
                        hintStyle: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black54,
                        )),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.85,
              height: 45.0,
              child: MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                  Fluttertoast.showToast(
                    msg: "Thank for your feedback!",
                    backgroundColor: Colors.black54,
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 3,
                  );
                },
                color: Colors.indigo,
                child: const Text(
                  "Submit Review",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
