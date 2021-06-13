import "../models/device.dart";
import "../global.dart";
import 'package:http/http.dart' as http;
import 'dart:convert';

class DeviceService {
  static String devicesUrl = "${Global.baseUrl}/userDevices";

  static Future<bool> postDevice(Object body) async {
    //name, parent
    bool responseCode = false;
    final response = await Global.h_post(devicesUrl, body, appendToken: true);
    // .then((http.Response resp) {
    if (200 <= response.statusCode && response.statusCode <= 300)
      responseCode = true;
    else
      responseCode = false;

    return responseCode;
  }

  static Future<bool> updateDevice(Object body, int deviceId) async {
    String url = "$devicesUrl/$deviceId";
    bool responseCode = false;
    final response = await Global.h_update(url, body, appendToken: true);
    if (200 <= response.statusCode && response.statusCode <= 300)
      responseCode = true;
    else
      responseCode = false;
    return responseCode;
  }

  static Future<List<Device>> getDevices() async {
    List<Device> devices = [];
    final response = await Global.h_get(devicesUrl, appendToken: true).then((http.Response response) async {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      List<dynamic> data = jsonResponse["data"];
      devices = List<Device>.from(data.map((model) {
        var device = Device.fromJson(model);

        return device;
      }));
    });
    return devices;
  }

  static Future<List<Device>> getDevicesByPlace(int placeId) async {
    String url = "${Global.baseUrl}/places/$placeId/userDevices";
    List<Device> devices = [];
    final response = await Global.h_get(url, appendToken: true).then((http.Response response) async {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      List<dynamic> data = jsonResponse['data'];

      devices = List<Device>.from(data.map((model) {
        var device = Device.fromJson(model);
        return device;
      }));
    });
    return devices;
  }

  static Future<Device> getDeviceById(int? deviceId) async {
    String url = "$devicesUrl/$deviceId";

    Device device = new Device(name: "sd");

    final response = await Global.h_get(url, appendToken: true).then((http.Response response) async {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      device = Device.fromJson(jsonResponse['data']);
    });

    return device;
  }

  static Future<bool> deleteDevice(int? deviceId) async {
    String url = "$devicesUrl/$deviceId";
    bool responseCode = false;
    final response = await Global.h_delete(url, appendToken: true);

    if (200 <= response.statusCode && response.statusCode <= 300)
      responseCode = true;
    else
      responseCode = false;
    return responseCode;
  }
}
