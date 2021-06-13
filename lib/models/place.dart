import 'package:flutter/material.dart';
import 'package:prototype/models/device.dart';

class Place {
  final int? id;
  int? parentId;
  final String? name;
  List<Place>? places;
  final List<Device>? deviceList;

  Place({this.id, this.parentId = -1, this.name, this.places, this.deviceList});

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
        id: json["id"],
        name: json["name"],
        parentId: json["parent_id"],
        places: [],
        deviceList: []);
  }
}
