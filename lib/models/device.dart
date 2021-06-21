import 'package:flutter/material.dart';
import './parameter.dart';

class Device {
  final String? id;
  final String? name;
  final String? macAddress;
  final String? ipAddress;
  final String? place;
  final List<Parameter>? parameters;

  const Device({this.id, @required this.name, this.ipAddress, this.macAddress, this.place, this.parameters});

  @override
  String toString() {
    return id.toString();
  }

  factory Device.fromJson(Map<String, dynamic> json) {
    var parameters = <Parameter>[];

    if (json['parameters'] != null) {
      json['parameters'].forEach((element) {
        String expected = element.keys.first;
        String name = element.values.first['name'];
        String unit = element.values.first['unit'];

        var parameter = Parameter(optName: name, expectedParameter: expected, unit: unit);

        parameters.add(parameter);
      });
    }

    var device = Device(
        place: json['place'] != null ? json['place']['name'] : '',
        id: json['id'],
        name: json['name'],
        macAddress: json['mac_address'] ?? '',
        ipAddress: json['ip_address'] ?? '',
        parameters: parameters);

    return device;
  }
}
