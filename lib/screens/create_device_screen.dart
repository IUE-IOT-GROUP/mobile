import 'package:flutter/material.dart';
import 'package:prototype/dummy_data.dart';
import 'package:prototype/models/device_type.dart';
import 'package:prototype/screens/main_screen.dart';
import 'package:prototype/widgets/create_device_textfield.dart';
import "../models/device.dart";
import "../models/place.dart";

class CreateDevice extends StatefulWidget {
  static const routeName = "/create-device";

  @override
  _CreateDeviceState createState() => _CreateDeviceState();
}

class _CreateDeviceState extends State<CreateDevice> {
  static final List devices = DUMMY_DEVICES;
  static final List<Place> places = DUMMY_PLACES;
  Device selectedDevice = devices[0];
  Place selectedPlace = places[0];
  final nameController = TextEditingController();
  final macAddressController = TextEditingController();
  final ipAddressController = TextEditingController();
  final appBar = AppBar(
    title: Text("Create New Device"),
  );

  void addDevice(
      String name, String ip, String mac, Place place, String type) {}

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return Scaffold(
      //appBar: appBar,
      body: Column(
        children: [
          Container(
              width: double.infinity,
              margin: EdgeInsets.only(right: 5, left: 5, top: 20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2),
              ),
              height: mq.size.height * 0.25,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.monitor,
                    size: 100,
                    color: Colors.black,
                  ),
                  Text(
                    "Add Device",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              )),
          CreateDeviceTextField(
              textString: "Name:",
              textController: nameController,
              isDropDown: false),
          CreateDeviceTextField(
              textString: "IP Address:",
              textController: ipAddressController,
              isDropDown: false),
          CreateDeviceTextField(
              textString: "MAC Address",
              textController: macAddressController,
              isDropDown: false),
          CreateDeviceTextField(
            textString: "Device Type",
            isDropDown: true,
            isDeviceType: true,
          ),
          CreateDeviceTextField(
            textString: "Place",
            isDropDown: true,
            isDeviceType: false,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          String enteredName = nameController.text;
          String enteredIp = ipAddressController.text;
          String enteredMac = macAddressController.text;
          Device dev = new Device(
              id: "${devices[devices.length - 1].id}.2",
              name: enteredName,
              protocol: "will be restored",
              type: new DeviceType("wbr", "will be restored"),
              ipAddress: enteredIp);
          Map<String, Device> args = {"device": dev};
          Navigator.of(context)
              .popAndPushNamed(MainScreen.routeName, arguments: args);
          // Place enteredPlace = places.first((P){})
        },
        backgroundColor: Colors.green,
        child: Icon(
          Icons.add,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
