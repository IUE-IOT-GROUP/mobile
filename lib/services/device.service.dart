import '../models/device.dart';
import '../global.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DeviceService {
  static String devicesUrl = '${Global.baseUrl}/devices';

  static Future<bool> postDevice(Object body) async {
    var responseCode = false;
    final response = await Global.h_post(devicesUrl, body, appendToken: true);
    if (200 <= response.statusCode && response.statusCode <= 300) {
      responseCode = true;
    } else {
      responseCode = false;
    }

    return responseCode;
  }

  static Future<bool> updateDevice(Object body, String deviceId) async {
    var url = '$devicesUrl/$deviceId';
    var responseCode = false;
    final response = await Global.h_update(url, body, appendToken: true);
    if (200 <= response.statusCode && response.statusCode <= 300) {
      responseCode = true;
    } else {
      responseCode = false;
    }
    return responseCode;
  }

  static Future<List<Device>> getDevices() async {
    var devices = <Device>[];
    await Global.h_get(devicesUrl, appendToken: true).then((http.Response response) async {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      List<dynamic> data = jsonResponse['data'];
      devices = List<Device>.from(data.map((model) {
        var device = Device.fromJson(model);

        return device;
      }));
    });
    return devices;
  }

  static Future<List<Device>> getDevicesByPlace(String placeId) async {
    var url = '${Global.baseUrl}/places/$placeId/devices';
    var devices = <Device>[];
    await Global.h_get(url, appendToken: true).then((http.Response response) async {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      List<dynamic> data = jsonResponse['data'];

      devices = List<Device>.from(data.map((model) {
        var device = Device.fromJson(model);
        return device;
      }));
    });
    return devices;
  }

  static Future<Device> getDeviceById(String? deviceId) async {
    var url = '$devicesUrl/$deviceId';

    var device = Device(name: 'sd');

    await Global.h_get(url, appendToken: true).then((http.Response response) async {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      device = Device.fromJson(jsonResponse['data']);
    });

    return device;
  }

  static Future<bool> deleteDevice(String? deviceId) async {
    var url = '$devicesUrl/$deviceId';
    var responseCode = false;
    final response = await Global.h_delete(url, appendToken: true);

    if (200 <= response.statusCode && response.statusCode <= 300) {
      responseCode = true;
    } else {
      responseCode = false;
    }
    return responseCode;
  }
}
