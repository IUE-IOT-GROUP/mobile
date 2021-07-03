import 'package:prototype/models/device.dart';
import 'package:prototype/models/device_data.dart';
import 'package:prototype/models/device_graph_data.dart';

class DeviceDataType {
  Device? device;
  String? id;
  String? name;
  String? unit;
  String? expectedParameter;
  List<DeviceData>? data;
  List<DeviceGraphData>? graphData;
  List<double?>? lastTen;
  double? min;
  double? max;
  double? average;
  double? min_y;
  double? max_y;
  String? min_x;
  DateTime? min_x_date;
  String? max_x;
  DateTime? max_x_date;

  DeviceDataType(
      Device device,
      String id,
      String name,
      String unit,
      String expectedParameter,
      List<DeviceData> data,
      List<DeviceGraphData> graphData,
      double min,
      double max,
      double average,
      double min_y,
      double max_y,
      String min_x,
      String max_x) {
    this.device = device;
    this.id = id;
    this.name = name;
    this.unit = unit;
    this.expectedParameter = expectedParameter;
    this.data = data;
    this.graphData = graphData;
    this.min = min;
    this.max = max;
    this.average = average;
    this.max_y = max_y;
    this.min_y = min_y;
    this.max_x = max_x;
    this.min_x = min_x;

    min_x_date = DateTime.parse(min_x);
    max_x_date = DateTime.parse(max_x);
  }

  factory DeviceDataType.fromJson(Device device, Map<String, dynamic> json) {
    Map<String, dynamic> details = json['details'];
    List<dynamic> deviceData = json['data'];
    List<dynamic> deviceGraphData = json['graphData'];
    var min_y = json['min_y'].toString();
    var max_y = json['max_y'].toString();
    String min_x = json['min_x'];
    String max_x = json['max_x'];
    print("min 66: ${json['min']}");
    var min = double.parse(json['min'].toString());
    print('min 68: $min');
    var max = double.parse(json['max'].toString());
    var average = double.parse(json['average'].toString());

    String id = details['device_parameter_id'];
    String expected = details['expected_parameter'];
    String name = details['name'];
    String unit = details['unit'];

    var data = <DeviceData>[];

    deviceData.forEach((element) {
      var devicedata = DeviceData(
          element['id'], element['value'].toString(), element['created_at']);

      data.add(devicedata);
    });

    var graphData = <DeviceGraphData>[];

    deviceGraphData.forEach((element) {
      var devicedata =
          DeviceGraphData(element['value'].toString(), element['created_at']);
      graphData.add(devicedata);
    });
    var deviceDataType = DeviceDataType(
        device,
        id,
        name,
        unit,
        expected,
        data,
        graphData,
        min,
        max,
        average,
        double.parse(min_y),
        double.parse(max_y),
        min_x,
        max_x);
    return deviceDataType;
  }
}
