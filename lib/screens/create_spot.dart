import 'dart:async';

import 'package:boardwalk/test/test_page.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as GMap;
import 'package:geolocator/geolocator.dart';

class CreateSpot extends StatefulWidget {
  static const id = 'create_spot';

  const CreateSpot({Key? key}) : super(key: key);

  @override
  State<CreateSpot> createState() => _CreateSpotState();
}

class _CreateSpotState extends State<CreateSpot> {
  int index = 0;
  Completer<GMap.GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: const Text(
          "Create Spot",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Add a title',
                ),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              child: Card(
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    color: Colors.black12,
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
                    maxLines: 6,
                    decoration: InputDecoration.collapsed(
                        hintText: "Host notification",
                        hintStyle: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black54,
                        )),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 20.0,
              ),
              child: Divider(
                thickness: 2.0,
                color: Colors.black26,
              ),
            ),
            Offstage(
              offstage: index != 0,
              child: TickerMode(
                enabled: index == 0,
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(
                        left: 20.0,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Setting Spot location",
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    SizedBox(
                      height: 50.0,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            color: Colors.black54,
                          ),
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                        ),
                        child: const Text(
                          "Search location / Address",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 20.0,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            index = 1;
                          });
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    SizedBox(
                      height: 50.0,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            color: Colors.blueAccent,
                          ),
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                        ),
                        child: const Text(
                          "Using current location",
                          style: TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 20.0,
                          ),
                        ),
                        onPressed: () async {},
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        top: 5.0,
                        left: 20.0,
                        bottom: 5.0,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Date and Time",
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 5.0,
                        left: 20.0,
                        bottom: 5.0,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: '0 hours 0 min ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                ),
                              ),
                              TextSpan(
                                text: 'to',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                              TextSpan(
                                text: ' 0 hours 0 min',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 5.0,
                        left: 20.0,
                        bottom: 5.0,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: '0 hours 0 min ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                ),
                              ),
                              TextSpan(
                                text: 'to',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                              TextSpan(
                                text: ' 0 hours 0 min',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Offstage(
              offstage: index != 1,
              child: TickerMode(
                enabled: index == 1,
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(
                        left: 20.0,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Meeting Place",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Center(
                      child: FutureBuilder<Position>(
                        future: Geolocator.getCurrentPosition(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          return SizedBox(
                            width: 350.0,
                            height: 150.0,
                            child: GMap.GoogleMap(
                              initialCameraPosition: GMap.CameraPosition(
                                target: GMap.LatLng(snapshot.data!.latitude,
                                    snapshot.data!.longitude),
                                zoom: 14.4746,
                              ),
                              onMapCreated:
                                  (GMap.GoogleMapController controller) {
                                _controller.complete(controller);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        left: 20.0,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Upcoming Event",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        left: 20.0,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Soccer",
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        left: 20.0,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Date and Time",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        left: 20.0,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "2021.11.08 PM 08:00 - PM 9:50",
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        left: 20.0,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "8-22 participate",
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        left: 20.0,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Requirement",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        left: 20.0,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "running shoes, casual attire",
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        left: 20.0,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Option",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        left: 20.0,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "water, snacks",
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    SizedBox(
                      height: 50.0,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: MaterialButton(
                        color: Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            50,
                          ),
                        ),
                        child: const Text(
                          "Request application for participation",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                          ),
                        ),
                        onPressed: () {},
                      ),
                    ),
                    const Center(
                      child: Text(
                        "11.08 오후 6시까지 참가 신청을 완료해주세요.",
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.arrow_forward,
          color: Colors.white,
        ),
        onPressed: () {
          // Navigator.pushNamed(context, TestPage.id);
        },
      ),
    );
  }
}
