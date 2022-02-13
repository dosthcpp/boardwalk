import 'dart:convert';

import 'package:http/http.dart' as http;


Future<List<dynamic>> getAddressFromLatLng(lat, long) async {
  final response = jsonDecode((await http.get(
      Uri.https('maps.googleapis.com',
          '/maps/api/geocode/json', {
            'latlng':
            '$lat,$long',
            'key': 'AIzaSyCmtuqJf6iBeCYLOv_R3clLdfXSkfiiUUw',
            'language': 'ko',
          })))
      .body)['results']
      .toList();
  return response;
}