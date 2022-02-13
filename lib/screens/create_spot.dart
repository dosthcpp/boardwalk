import 'dart:async';
import 'dart:convert';

import 'package:boardwalk/main.dart';
import 'package:boardwalk/test/scan_loc.dart';
import 'package:boardwalk/test/test_page.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as GMap;
import 'package:geolocator/geolocator.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart'
    show Marker, MarkerId, LatLng;

import 'package:boardwalk/api/api_service.dart';

import 'package:boardwalk/utils.dart';

class CreateSpot extends StatefulWidget {
  static const id = 'create_spot';

  const CreateSpot({Key? key}) : super(key: key);

  @override
  State<CreateSpot> createState() => _CreateSpotState();
}

class _CreateSpotState extends State<CreateSpot> {
  Completer<GMap.GoogleMapController> _controller = Completer();
  final ApiService _apiService = ApiService();

  int index = 0;
  bool isBack = false;
  bool usingCurrentLoc = false;
  int supplyIdentifier = 1;
  List<CustomSupplyInput> fields = [];

  int optionalSupplyIdentifier = 1;
  List<CustomSupplyInput> optionalFields = [];

  int _minParticipants = 1;
  int _maxParticipants = 10;

  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now();

  // '21.10.11(Sun) 6AM~8:30AM'
  dynamic dayData =
      '{ "1" : "Mon", "2" : "Tue", "3" : "Wed", "4" : "Thur", "5" : "Fri", "6" : "Sat", "7" : "Sun" }';

  String get getStartTime =>
      "${startTime.month < 10 ? '0${startTime.month}' : startTime.month}.${startTime.day < 10 ? '0${startTime.day}' : startTime.day}.${startTime.year.toString().substring(2)} (${json.decode(dayData)['${startTime.weekday}']}) ${startTime.hour >= 12 ? 'PM' : 'AM'} ${startTime.hour > 12 ? startTime.hour - 12 : '${startTime.hour < 10 ? '0${startTime.hour}' : startTime.hour}'}:${startTime.minute < 10 ? '0${startTime.minute}' : startTime.minute}";

  String get getEndTime =>
      "${endTime.month < 10 ? '0${endTime.month}' : endTime.month}.${endTime.day < 10 ? '0${endTime.day}' : endTime.day}.${endTime.year.toString().substring(2)} (${json.decode(dayData)['${startTime.weekday}']}) ${endTime.hour >= 12 ? 'PM' : 'AM'} ${endTime.hour > 12 ? endTime.hour - 12 : '${endTime.hour < 10 ? '0${endTime.hour}' : endTime.hour}'}:${endTime.minute < 10 ? '0${endTime.minute}' : endTime.minute}";

  String title = '', notification = '', address = '', event = '';
  List<double> coordinate = [];
  List<int> participants = [];
  Map<int, String> necessarySupplies = {};
  Map<int, String> optionalSupplies = {};

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
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Add a title',
                ),
                onChanged: (_title) {
                  title = _title;
                },
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 10.0,
                  ),
                  child: TextField(
                    maxLines: 6,
                    decoration: const InputDecoration.collapsed(
                      hintText: "Host notification",
                      hintStyle: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black54,
                      ),
                    ),
                    onChanged: (_notification) {
                      notification = _notification;
                    },
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
            SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
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
                                  onPressed: () async {
                                    Navigator.pushNamed(
                                            context, ScanLocation.id)
                                        .then((_) {
                                      setState(() {
                                        index = 1;
                                      });
                                      isBack = true;
                                    });
                                    // var isBack = await Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (context) => ScanLocation(),
                                    //   ),
                                    // );
                                    // print(isBack);
                                    // if (isBack && !(mapProvider.getLat == 0.0 && mapProvider.getLng == 0.0)) {
                                    //   setState(() {
                                    //     index = 1;
                                    //   });
                                    //   print(mapProvider.getLat);
                                    //   print(mapProvider.getLng);
                                    // }
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
                                  onPressed: () async {
                                    setState(() {
                                      usingCurrentLoc = true;
                                      index = 1;
                                    });
                                  },
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
                              isBack && !usingCurrentLoc
                                  ? Center(
                                      child: Builder(
                                        builder: (context) {
                                          List<Marker> _markers = [];
                                          _markers.add(
                                            Marker(
                                              markerId: MarkerId("1"),
                                              draggable: true,
                                              onTap: () => print("Marker!"),
                                              position: LatLng(
                                                mapProvider.getLat,
                                                mapProvider.getLng,
                                              ),
                                            ),
                                          );
                                          return SizedBox(
                                            width: 350.0,
                                            height: 150.0,
                                            child: GMap.GoogleMap(
                                              markers: _markers.toSet(),
                                              initialCameraPosition:
                                                  GMap.CameraPosition(
                                                target: GMap.LatLng(
                                                  mapProvider.getLat,
                                                  mapProvider.getLng,
                                                ),
                                                zoom: 14.4746,
                                              ),
                                              onMapCreated:
                                                  (GMap.GoogleMapController
                                                      controller) {
                                                if (!_controller.isCompleted) {
                                                  _controller
                                                      .complete(controller);
                                                }
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  : Center(
                                      child: FutureBuilder<Position>(
                                        future: Geolocator.getCurrentPosition(),
                                        builder: (context, snapshot) {
                                          List<Marker> _markers = [];
                                          if (!snapshot.hasData) {
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          } else {
                                            _markers.add(
                                              Marker(
                                                markerId: MarkerId("1"),
                                                draggable: true,
                                                onTap: () => print("Marker!"),
                                                position: LatLng(
                                                  snapshot.data!.latitude,
                                                  snapshot.data!.longitude,
                                                ),
                                              ),
                                            );

                                            coordinate = [
                                              snapshot.data!.latitude,
                                              snapshot.data!.longitude
                                            ];
                                            return FutureBuilder<List<dynamic>>(
                                                future: getAddressFromLatLng(
                                                    snapshot.data!.latitude,
                                                    snapshot.data!.longitude),
                                                builder: (context, _snapshot) {
                                                  // address = _snapshot.data![0];
                                                  var fulladdr = (_snapshot
                                                                  .data ??
                                                              [
                                                                {
                                                                  'formatted_address':
                                                                      ''
                                                                }
                                                              ])[0]
                                                          ['formatted_address']
                                                      .toString()
                                                      .trim();
                                                  if (fulladdr
                                                          .split(' ')
                                                          .length >
                                                      3) {
                                                    address = fulladdr;
                                                  }
                                                  return SizedBox(
                                                    width: 350.0,
                                                    height: 150.0,
                                                    child: GMap.GoogleMap(
                                                      markers: _markers.toSet(),
                                                      initialCameraPosition:
                                                          GMap.CameraPosition(
                                                        target: GMap.LatLng(
                                                          snapshot
                                                              .data!.latitude,
                                                          snapshot
                                                              .data!.longitude,
                                                        ),
                                                        zoom: 14.4746,
                                                      ),
                                                      onMapCreated: (GMap
                                                              .GoogleMapController
                                                          controller) {
                                                        if (!_controller
                                                            .isCompleted) {
                                                          _controller.complete(
                                                              controller);
                                                        }
                                                      },
                                                    ),
                                                  );
                                                });
                                          }
                                        },
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      )
                    ],
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
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                    ),
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'Soccer',
                      ),
                      onChanged: (_event) {
                        event = _event;
                      },
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
                  InkWell(
                    onTap: () {
                      DatePicker.showDateTimePicker(
                        context,
                        showTitleActions: true,
                        minTime: DateTime.now(),
                        maxTime: DateTime(2025, 12, 31),
                        onChanged: (date) {
                          print('change $date');
                        },
                        onConfirm: (date) {
                          if (date.isAfter(endTime)) {
                            showDialog(
                                context: context,
                                //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    //Dialog Main Title
                                    title: Column(
                                      children: const [
                                        Text("경고"),
                                      ],
                                    ),
                                    //
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: const [
                                        Text(
                                          "Start time must be before the end time.",
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        child: Text("ok."),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  );
                                });
                            return;
                          } else {
                            setState(() {
                              startTime = date;
                            });
                            print(endTime);
                            print(date);
                          }
                        },
                        currentTime: DateTime.now(),
                        locale: LocaleType.en,
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 20.0,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "$getStartTime - ",
                          style: const TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  InkWell(
                    onTap: () {
                      DatePicker.showDateTimePicker(
                        context,
                        showTitleActions: true,
                        minTime: DateTime.now(),
                        maxTime: DateTime(2025, 12, 31),
                        onChanged: (date) {
                          print('change $date');
                        },
                        onConfirm: (date) {
                          if (date.isBefore(startTime)) {
                            showDialog(
                                context: context,
                                //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    //Dialog Main Title
                                    title: Column(
                                      children: const [
                                        Text("경고"),
                                      ],
                                    ),
                                    //
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: const [
                                        Text(
                                          "End time must be after the start time.",
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        child: Text("ok."),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  );
                                });
                            return;
                          } else {
                            setState(() {
                              endTime = date;
                            });
                          }
                        },
                        currentTime: DateTime.now(),
                        locale: LocaleType.en,
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 20.0,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          getEndTime,
                          style: const TextStyle(
                            fontSize: 18.0,
                          ),
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
                        "Participants",
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
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20.0,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          NumberPicker(
                            value: _minParticipants,
                            minValue: 1,
                            maxValue: _maxParticipants - 1,
                            onChanged: (value) {
                              if (value >= _maxParticipants) {
                                return;
                              }
                              setState(() => _minParticipants = value);
                            },
                          ),
                          const Text('~'),
                          NumberPicker(
                            value: _maxParticipants,
                            minValue: _minParticipants + 1,
                            maxValue: 100,
                            onChanged: (value) {
                              if (value <= _minParticipants) {
                                return;
                              }
                              setState(() => _maxParticipants = value);
                            },
                          ),
                        ],
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
                        "Necessary supplies",
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
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 9,
                              child: TextField(onChanged: (supply) {
                                necessarySupplies[0] = supply;
                              }),
                            ),
                            Expanded(
                              child: MaterialButton(
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5.0,
                                ),
                                minWidth: 0,
                                onPressed: () {
                                  setState(() {
                                    fields.add(CustomSupplyInput(
                                      onChanged: (supply, id) {
                                        necessarySupplies[id] = supply;
                                      },
                                      identifier: supplyIdentifier,
                                      cb: (id) {
                                        necessarySupplies
                                            .removeWhere((k, v) => k == id);
                                        setState(() {
                                          fields.removeWhere(
                                              (el) => el.identifier == id);
                                        });
                                      },
                                    ));
                                  });
                                  supplyIdentifier++;
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
                            ),
                          ],
                        ),
                        ...fields,
                      ],
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
                        "Optional supplies",
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
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 9,
                              child: TextField(
                                onChanged: (supply) {
                                  optionalSupplies[0] = supply;
                                },
                              ),
                            ),
                            Expanded(
                              child: MaterialButton(
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5.0,
                                ),
                                minWidth: 0,
                                onPressed: () {
                                  setState(() {
                                    optionalFields.add(CustomSupplyInput(
                                      onChanged: (supply, id) {
                                        optionalSupplies[id] = supply;
                                        print(optionalSupplies);
                                      },
                                      identifier: optionalSupplyIdentifier,
                                      cb: (id) {
                                        optionalSupplies
                                            .removeWhere((k, v) => k == id);
                                        setState(() {
                                          optionalFields.removeWhere(
                                              (el) => el.identifier == id);
                                        });
                                        optionalSupplyIdentifier--;
                                      },
                                    ));
                                  });
                                  optionalSupplyIdentifier++;
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
                            ),
                          ],
                        ),
                        ...optionalFields,
                      ],
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
                        "Open Session",
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 20.0,
                        ),
                      ),
                      onPressed: () async {
                        List<double> coord = [];
                        if (isBack && !usingCurrentLoc) {
                          address = mapProvider.getAddr();
                          coord = [mapProvider.getLng, mapProvider.getLat];
                        } else {
                          coord = coordinate;
                        }
                        if(address.startsWith("대한민국")) {
                          address = address.substring(5);
                        }
                        SessionArgs args = SessionArgs(
                          host: userProvider.getNickname(),
                          title: title,
                          notification: notification,
                          address: address,
                          coordinate: coord,
                          event: event,
                          startTime: getStartTime,
                          endTime: getEndTime,
                          participants: [_minParticipants, _maxParticipants],
                          necessarySupplies: necessarySupplies.values.toList(),
                          optionalSupplies: optionalSupplies.values.toList(),
                        );
                        await _apiService.openSession(args);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 50.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: const Icon(
      //     Icons.arrow_forward,
      //     color: Colors.white,
      //   ),
      //   onPressed: () {
      //     Navigator.pushNamed(context, TestPage.id);
      //   },
      // ),
    );
  }
}

class CustomSupplyInput extends StatelessWidget {
  final void Function(int) cb;
  final void Function(String, int) onChanged;
  final int identifier;

  CustomSupplyInput(
      {Key? key,
      required this.cb,
      required this.onChanged,
      required this.identifier})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 9,
          child: TextField(
            onChanged: (val) {
              onChanged(val, identifier);
            },
          ),
        ),
        Expanded(
          child: MaterialButton(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding: const EdgeInsets.symmetric(
              horizontal: 5.0,
            ),
            minWidth: 0,
            onPressed: () {
              cb(identifier);
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
                Icons.remove,
                color: Colors.black54,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
