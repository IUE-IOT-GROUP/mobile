import 'dart:collection';

import 'package:prototype/models/device_data.dart';
import 'package:prototype/models/device_data_type.dart';

import "../global.dart";
import 'package:http/http.dart' as http;
import 'dart:convert';

class DeviceDataService {
  static String deviceDataUrl = "${Global.baseUrl}/devices/data";

  static Future<List<DeviceDataType>> getDeviceData(int? deviceId) async {
    String url = "$deviceDataUrl/$deviceId";

    List<DeviceDataType> deviceDataTypes = [];

    final response = await Global.h_get(url, appendToken: true)
        .then((http.Response response) async {
      print("ggg: ${response.body}");
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      List<dynamic> data = jsonResponse['data'];

      deviceDataTypes = List<DeviceDataType>.from(data.map((model) {
        var deviceDataType = DeviceDataType.fromJson(model);
        return deviceDataType;
      }));
    });

    // print(deviceDataTypes);
    print("habba: ${deviceDataTypes.length}");
    return deviceDataTypes;
  }
}
