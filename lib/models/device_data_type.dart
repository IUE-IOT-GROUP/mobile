import 'package:prototype/models/device_data.dart';

class DeviceDataType {
  final String? name;
  final String? unit;
  final String? expectedParameter;
  final List<DeviceData>? data;
  final double? min;
  final double? max;

  const DeviceDataType(
      {this.name,
      this.unit,
      this.expectedParameter,
      this.data,
      this.max,
      this.min});

  factory DeviceDataType.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> details = json["details"];
    List<dynamic> deviceData = json["data"];
    String min = json["min"];
    String max = json["max"];

    String expected = details["expected_parameter"];
    String name = details["name"];
    String unit = details["unit"];

    List<DeviceData> data = [];

    deviceData.forEach((element) {
      DeviceData devicedata = new DeviceData(
          element["id"], element["value"], element["created_at"]);

      data.add(devicedata);
    });
    print("datatype-37: $min");
    print("datatype-37: $max");
    print("datatype-37: ");
    DeviceDataType deviceDataType = new DeviceDataType(
        name: name,
        unit: unit,
        expectedParameter: expected,
        data: data,
        max: double.parse(max),
        min: double.parse(min));

    return deviceDataType;
  }
}
