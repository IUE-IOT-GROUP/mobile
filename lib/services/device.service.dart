import "../models/device.dart";
import "../global.dart";
import 'package:http/http.dart' as http;
import 'dart:convert';

class DeviceService {
  static String devicesUrl = "${Global.baseUrl}/userDevices";

  static Future<bool> postDevice(Object body) async {
    //name, parent
    bool responseCode = false;
    final response = await Global.post(devicesUrl, body, appendToken: true);
    // .then((http.Response resp) {
    if (200 <= response.statusCode && response.statusCode <= 300)
      responseCode = true;
    else
      responseCode = false;
    print("316responsecode: ${response.statusCode}");
    // print(response);
    print("316${response.body}");
    return responseCode;
  }

  static Future<List<Device>> getDevices() async {
    List<Device> devices = [];
    final response = await Global.h_get(devicesUrl, appendToken: true)
        .then((http.Response response) async {
      print("28${response.body}");
    });
    return devices;
  }

  static Future<List<Device>> getDevicesByPlace(int placeId) async {
    String url = "${Global.baseUrl}/places/$placeId/userDevices";
    List<Device> devices = [];
    final response = await Global.h_get(url, appendToken: true)
        .then((http.Response response) async {
      print("333${response.body}");
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      List<dynamic> data = jsonResponse['data'];
      devices = List<Device>.from(data.map((model) {
        var device = Device.fromJson(model);
        print("device_service-42 ${model}");
        return device;
      }));
    });
    return devices;
  }
}
