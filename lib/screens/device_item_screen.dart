import 'package:flutter/material.dart';
import 'package:prototype/widgets/custom%20device%20items/humidity.dart';
import "../widgets/custom device items/temperature_item.dart";
import "../models/device.dart";
import "../SecureStorage.dart";
import '../widgets/custom device items/graphs/humidity_graph.dart';

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
    Device device = new Device();
    return device;
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text(
          "Device name",
          style: TextStyle(color: Theme.of(context).accentColor),
        ),
        backgroundColor: Color.fromRGBO(255, 255, 255, .02),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 10, top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 5, left: 5),
                child: TemperatureItem(25),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5, left: 5),
                child: HumidityItem(50),
              )
            ],
          ),
        ),
      ),
      // TemperatureItem(25),
    );
  }
}
