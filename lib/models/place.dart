import 'package:flutter/material.dart';
import 'package:prototype/models/device.dart';

class Place {
  final int id;
  final String name;
  final List<Place> placeList;
  final List<Device> deviceList;

  const Place(
      @required this.id, @required this.name, this.placeList, this.deviceList);
}
