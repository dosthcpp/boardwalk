import 'dart:convert';

import 'package:boardwalk/main.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:http/http.dart' as http;

import 'package:boardwalk/utils.dart';

class ScanLocation extends StatefulWidget {
  static const id = 'scan_location';

  @override
  State<ScanLocation> createState() => _ScanLocationState();
}

class _ScanLocationState extends State<ScanLocation> {
  List<String> suggestions = [];
  List<dynamic> searchResult = [];
  String searchTerm = '';
  String address = '';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
            ),
            color: Colors.black,
            onPressed: () {
              googleSignIn.disconnect();
              Navigator.pop(context);
            },
          ),
          title: SizedBox(
            height: 35.0,
            child: TextField(
              onChanged: (term) async {
                setState(() {
                  searchTerm = term;
                });
                try {
                  var res = await http.post(
                    Uri.https(
                      'juso.go.kr',
                      '/addrlink/addrLinkApiJsonp.do',
                      {
                        'confmKey': 'devU01TX0FVVEgyMDIxMTIwMzAwNTQxMDExMTk4Njc=',
                        'keyword': term,
                        'resultType': 'json'
                      },
                    ),
                  );
                  Map<String, dynamic> results = jsonDecode(
                      res.body.replaceAll("(", "").replaceAll(")", ""));
                  setState(() {
                    searchResult = results['results']['juso']
                        ?.map((addr) => addr['roadAddr'].toString())
                        ?.toList()!;
                  });
                } catch (e) {
                  searchResult = [];
                }
              },
              decoration: InputDecoration(
                hintText: "동명(읍, 면)으로 검색 (ex. 신도림동)",
                hintStyle: TextStyle(
                  color: Colors.grey[300],
                  fontWeight: FontWeight.normal,
                  fontSize: 15.0,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 0.0,
                  horizontal: 10.0,
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                    width: 1.5,
                  ),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: FutureBuilder<Position>(
                      future: Geolocator.getCurrentPosition(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        return MaterialButton(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.location_searching,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.05,
                              ),
                              const Text(
                                "현재위치로 찾기",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                          color: Colors.blue,
                          onPressed: () async {
                            setState(
                              () {
                                suggestions.clear();
                              },
                            );
                            try {
                              final response = await getAddressFromLatLng(snapshot.data!.latitude, snapshot.data!.longitude);
                              // final response = jsonDecode((await http.get(
                              //             Uri.https('maps.googleapis.com',
                              //                 '/maps/api/geocode/json', {
                              //   'latlng':
                              //       '${snapshot.data!.latitude},${snapshot.data!.longitude}',
                              //   'key': 'AIzaSyCmtuqJf6iBeCYLOv_R3clLdfXSkfiiUUw',
                              //   'language': 'ko',
                              // })))
                              //         .body)['results']
                              //     .toList();
                              response.forEach(
                                (addr) {
                                  var fulladdr =
                                      addr['formatted_address'].toString().trim();
                                  if (fulladdr.split(' ').length > 3) {
                                    setState(() {
                                      suggestions.add(fulladdr);
                                    });
                                  }
                                },
                              );
                            } catch (e) {
                              print(e);
                            }
                          },
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          searchTerm.isNotEmpty
                              ? "Search result of \'$searchTerm\'"
                              : "Neighborhoods near my location",
                        ),
                      ),
                      ListView.builder(
                        padding: const EdgeInsets.all(8),
                        shrinkWrap: true,
                        primary: false,
                        itemCount: searchTerm.isNotEmpty
                            ? searchResult.length
                            : suggestions.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (index == 0) {
                            return const SizedBox();
                          }
                          return InkWell(
                            onTap: () {
                              if (searchTerm.isNotEmpty) {
                                setState(() {
                                  mapProvider.setAddress(searchResult[index]);
                                  address = searchResult[index];
                                });
                              } else {
                                setState(() {
                                  var suggestion =
                                      suggestions[index].replaceAll('대한민국 ', "");
                                  mapProvider.setAddress(suggestion);
                                  address = suggestion;
                                });
                              }
                            },
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    searchTerm.isNotEmpty
                                        ? searchResult[index]
                                        : suggestions[index],
                                  ),
                                ),
                                const Divider(
                                  thickness: 2.0,
                                  color: Colors.black54,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.1,
                    horizontal: 20.0,
                  ),
                  child: Text(
                    "Selected address : $address",
                    style: const TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            var res = await http.get(
              Uri.https(
                'api.vworld.kr',
                '/req/address',
                {
                  'service': 'address',
                  'request': 'getcoord',
                  'version': '2.0',
                  'crs': 'epsg:4326',
                  'address': address,
                  'refine': 'true',
                  'simple': 'false',
                  'format': 'json',
                  'type': 'road',
                  'key': '9BC5BC5C-EFD0-33B3-A894-4B286504B74A',
                },
              ),
            );
            var lat = json.decode(res.body)['response']['result']['point']['y'];
            var lng = json.decode(res.body)['response']['result']['point']['x'];
            mapProvider.setLatLng(
              double.tryParse(lat) ?? 0.0,
              double.tryParse(lng) ?? 0.0,
            );
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.check,
          ),
        ),
      ),
    );
  }
}
