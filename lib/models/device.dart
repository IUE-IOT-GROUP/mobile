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
  final List<Parameter>? parameters;

  const Device(
      {this.id,
      @required this.name,
      this.ipAddress,
      this.macAddress,
      this.place,
      this.parameters});

  factory Device.fromJson(Map<String, dynamic> json) {
    List<Parameter> parameters = [];

    json['parameters'].forEach((element) {
      String expected = element.keys.first;
      String name = element.values.first["name"];
      String unit = element.values.first["unit"];

      Parameter parameter =
          new Parameter(optName: name, expectedParameter: expected, unit: unit);

      parameters.add(parameter);
    });

    Device device = new Device(
        place: json["place"]["name"],
        id: json["id"],
        name: json["name"],
        macAddress: json["mac_address"],
        ipAddress: json["ip_address"],
        parameters: parameters);

    return device;
  }
}
