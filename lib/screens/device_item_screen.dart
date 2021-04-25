import 'package:flutter/material.dart';
import 'package:prototype/widgets/custom%20device%20items/temperature_item.dart';
import "../models/device.dart";
import "../SecureStorage.dart";

class DeviceItemScreen extends StatefulWidget {
  static const routeName = "/device-item-screen";
  @override
  _DeviceItemScreenState createState() => _DeviceItemScreenState();
}

class _DeviceItemScreenState extends State<DeviceItemScreen> {
  Future<Device> fetchDevice() async {
    SecureStorage storage = SecureStorage();
    int device_id = await storage.readSecureData("device id") as int;
    print(device_id);
    //SELECT * FROM devices WHERE id = device_id
    Device device = new Device(
        id: device_id, name: "Test_dev", protocol: " protocol", type: null);
    return device;
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: mq.width * 0.8,
            height: mq.height * 0.3,
            margin: EdgeInsets.only(
                left: mq.width * 0.1,
                right: mq.width * 0.1,
                top: mq.height * 0.04,
                bottom: mq.height * 0.02),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Device Name",
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                ),
                Icon(
                  Icons.settings,
                  size: 100,
                ),
              ],
            ),
          ),
          Container(
            width: mq.width * 0.65,
            height: mq.height * 0.6,
            margin: EdgeInsets.only(
              left: mq.width * 0.175,
              right: mq.width * 0.175,
              bottom: mq.height * 0.04,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [TemperatureItem(25)],
            ),
          ),
          // TemperatureItem(25),
        ],
      ),
    );
  }
}
