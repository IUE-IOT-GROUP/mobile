import 'package:prototype/models/device.dart';
import 'package:prototype/models/device_data_type.dart';
import '../global.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DeviceDataService {
  static String deviceDataUrl = '${Global.baseUrl}/devices/data';

  static Future<List<DeviceDataType>> getDeviceData(Device? device) async {
    var url = '$deviceDataUrl/${device!.id}';

    var deviceDataTypes = <DeviceDataType>[];

    await Global.h_get(url, appendToken: true)
        .then((http.Response response) async {
      // print('getDeviceData body: ${response.body}');
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      List<dynamic> data = jsonResponse['data'];
      // print('getDeviceData data $data');

      deviceDataTypes = List<DeviceDataType>.from(data.map((model) {
        var deviceDataType = DeviceDataType.fromJson(device, model);
        print('getDeviceData $deviceDataType');
        print('getDeviceData device $device');
        print('getDeviceData model $model');
        return deviceDataType;
      }));
    });
    print('getDeviceData $deviceDataTypes');

    return deviceDataTypes;
  }

  static Future<DeviceDataType> getDeviceDataByPeriod(
      DeviceDataType deviceDataType, String period) async {
    var url =
        '$deviceDataUrl/${deviceDataType.device!.id}/${deviceDataType.id}?period=$period';

    await Global.h_get(url, appendToken: true)
        .then((http.Response response) async {
      print('Device Data service 37: ${response.body}');
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      Map<String, dynamic> data = jsonResponse['data'];
      deviceDataType = DeviceDataType.fromJson(deviceDataType.device!, data);
      print('device data service 40: $deviceDataType');
    });

    return deviceDataType;
  }
}
