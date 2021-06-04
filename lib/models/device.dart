import 'package:flutter/material.dart';
import "./device_type.dart";
import './place.dart';
import "./parameter.dart";

class Device {
  final int? id;
  final String? name;
  final String? macAddress;
  final String? ipAddress;
  final String? place;
  final Map? parameters;

  const Device(
      {this.id,
      @required this.name,
      this.ipAddress,
      this.macAddress,
      this.place,
      this.parameters});

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
        place: json["place_id"],
        id: json["device_id"],
        name: json["name"],
        macAddress: json["mac_address"],
        ipAddress: json["ip_address"],
        parameters: json["parameters"]);
  }
}
