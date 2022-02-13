import 'package:flutter/material.dart';

class MapProvider with ChangeNotifier {
  String _address = '';
  double _lat = 0.0, _lng = 0.0;

  void setAddress(addr) {
    _address = addr;
    notifyListeners();
  }

  String getAddr() {
    return _address;
  }

  void setLatLng(lat, lng) {
    _lat = lat;
    _lng = lng;
  }

  get getLat => _lat;
  get getLng => _lng;
}
