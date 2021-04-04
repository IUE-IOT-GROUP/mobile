import "./device.dart";

class Room {
  final String? id;
  final String? name;
  final List<Device> deviceList;

  const Room(this.id, this.name, this.deviceList);
}
