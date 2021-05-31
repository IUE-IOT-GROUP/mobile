import 'package:flutter/material.dart';
import "./device_type.dart";
import './place.dart';
import "./parameter.dart";

class Device {
  final int? id;
  final String? name;
  final String? macAddress;
  final String? ipAddress;
  final Place? place;
  final Map? parameters;

  const Device(
      {@required this.id,
      @required this.name,
      this.ipAddress,
      this.macAddress,
      this.place,
      this.parameters});
}
