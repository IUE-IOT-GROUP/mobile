import 'package:flutter/material.dart';
import "./device_type.dart";

class Device {
  final int? id;
  final String? name;
  final String? protocol;
  final String? ipAddress;
  final DeviceType? type;

  const Device(
      {@required this.id,
      @required this.name,
      @required this.protocol,
      @required this.type,
      this.ipAddress});
}
