import 'dart:math';
import 'package:flutter/material.dart';
import 'package:prototype/dummy_data.dart';
import 'package:prototype/global.dart';
import 'package:prototype/models/device.dart';
import 'package:prototype/models/device_type.dart';
import 'package:prototype/screens/main_screen.dart';
import 'package:prototype/widgets/create_device_textfield.dart';
import "../models/place.dart";
import "../widgets/navDrawer.dart";

class CreateDevice extends StatefulWidget {
  static const routeName = "/create-device";

  @override
  _CreateDeviceState createState() => _CreateDeviceState();
}

class _CreateDeviceState extends State<CreateDevice> {
  static final List devices = DUMMY_DEVICES;
  static final List<Place> places = DUMMY_PLACES;
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
      drawer: NavDrawer(),
      appBar: AppBar(),
      backgroundColor: Theme.of(context).primaryColor,
      resizeToAvoidBottomInset: false,
      //appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                width: double.infinity,
                margin: EdgeInsets.only(right: 5, left: 5, top: 20),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Theme.of(context).accentColor, width: 2),
                ),
                height: mq.size.height * 0.25,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.monitor,
                      size: 100,
                      color: Theme.of(context).accentColor,
                    ),
                    Text(
                      "Add Device",
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          String enteredName = nameController.text;
          String enteredIp = ipAddressController.text;
          String enteredMac = macAddressController.text;

          Random random = new Random();
          final id = random.nextInt(10000);
          Device newDevice = new Device(
            id: id,
            name: enteredName,
            protocol: "HTTP",
            ipAddress: enteredIp,
            type: DeviceType("12", "temporarily disabled"),
          );
          Global.devices.add(newDevice);

          Global.initialState = 1;

          Navigator.of(context).popAndPushNamed(MainScreen.routeName);
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
