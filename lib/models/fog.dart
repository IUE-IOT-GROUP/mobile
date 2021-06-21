import 'package:prototype/models/place.dart';

class Fog {
  String? id;
  String? name;
  String? macAddress;
  String? ipAddress;
  String? port;

  Fog(String? id, String? name, String? macAddress, String? ipAddress, String? port) {
    this.id = id;
    this.name = name;
    this.macAddress = macAddress;
    this.ipAddress = ipAddress;
    this.port = port;
  }

  factory Fog.fromJson(Map<String, dynamic> json) {
    var fog = Fog(json['id'], json['name'], json['macAddress'], json['ipAddress'], json['port']);

    return fog;
  }
}
