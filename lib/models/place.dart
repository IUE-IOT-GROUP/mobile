import 'package:prototype/models/device.dart';

class Place {
  final String? id;
  String? parentId;
  final String? name;
  List<Place>? places;
  final List<Device>? deviceList;

  Place({this.id, this.parentId, this.name, this.places, this.deviceList});

  factory Place.fromJson(Map<String, dynamic> json) {
    var places = <Place>[];
    var devices = <Device>[];

    if (json['places'] != null) {
      List<dynamic?>? subPlaces = json['places'];

      if (subPlaces!.isNotEmpty) {
        subPlaces.forEach((element) {
          places.add(Place.fromJson(element));
        });
      }
    }

    if (json['devices'] != null) {
      List<dynamic?>? subDevices = json['devices'];

      if (subDevices!.isNotEmpty) {
        subDevices.forEach((element) {
          var device = Device.fromJson(element);
          devices.add(device);
        });
      }
    }

    var place = Place(id: json['id'], name: json['name'], parentId: json['parent_id'], places: places, deviceList: devices);

    return place;
  }
}
