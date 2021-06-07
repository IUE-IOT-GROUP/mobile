import 'package:prototype/models/device_data.dart';

class DeviceDataType {
  final String? name;
  final String? unit;
  final String? expectedParameter;
  final List<DeviceData>? data;

  const DeviceDataType(
      {this.name, this.unit, this.expectedParameter, this.data});

  factory DeviceDataType.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> details = json["details"];
    List<dynamic> deviceData = json["data"];

    String expected = details["expected_parameter"];
    String name = details["name"];
    String unit = details["unit"];

    List<DeviceData> data = [];

    deviceData.forEach((element) {
      DeviceData devicedata = new DeviceData(
          element["id"], element["value"], element["created_at"]);

      data.add(devicedata);
    });

    DeviceDataType deviceDataType = new DeviceDataType(
        name: name, unit: unit, expectedParameter: expected, data: data);

    return deviceDataType;
  }
}
