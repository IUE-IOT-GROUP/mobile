import 'package:flutter/material.dart';
import 'package:prototype/models/device.dart';

class Place {
  final int? id;
  int? parentId;
  final String? name;
  final List<Place>? placeList;
  final List<Device>? deviceList;

  Place(
      {this.id,
      this.parentId = -1,
      this.name,
      this.placeList,
      this.deviceList});
}
