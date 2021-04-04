import 'package:flutter/material.dart';
import 'package:prototype/dummy_data.dart';
import 'package:prototype/screens/create_device_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import "../models/device.dart";
import "../models/place.dart";
import "../models/device_type.dart";
import "../widgets/device_list.dart";
import "../widgets/place_list.dart";
import "dart:math";
import "../SecureStorage.dart";

class MainScreen extends StatefulWidget {
  static const routeName = "/main-screen";
  final String username = "";

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Device> devices = [];
  List<Place> places = DUMMY_PLACES;
  final SecureStorage secureStorage = SecureStorage();
  String username = '';
  String new_device_name = "";
  String new_device_ip = "";
  String new_device_type = "";

  fetchAndAddNewDevice() async {
    String name = await secureStorage.readSecureData("new_device_name");
    String type = await secureStorage.readSecureData("new_device_type");
    String ip = await secureStorage.readSecureData("new_device_ip");
    Random random = new Random();
    final id = random.nextInt(10000).toString();
    if (name != null && type != null && ip != null) {
      setState(() {
        new_device_name = name;
        new_device_ip = ip;
        new_device_type = type;
        Device new_device = new Device(
            id: id,
            name: new_device_name,
            protocol: "HTTP",
            ipAddress: new_device_ip,
            type: DeviceType("12", new_device_type));
        devices.add(new_device);
      });
    }
    secureStorage.deleteSecureData("new_device_name");
    secureStorage.deleteSecureData("new_device_type");
    secureStorage.deleteSecureData("new_device_ip");
  }

  loadUsername() async {
    String response = await secureStorage.readSecureData("username");

    setState(() {
      username = response;
    });
  }

  @override
  void initState() {
    super.initState();

    loadUsername();
    fetchAndAddNewDevice();
  }

  AppBar showAppBar() {
    return AppBar(
      title: Text(username),
      bottom: TabBar(
        tabs: [
          Tab(icon: Icon(Icons.devices), text: "Your Devices"),
          Tab(icon: Icon(Icons.home), text: "Your Areas"),
        ],
      ),
    );
  }

  void startAddNewDevice(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(
      CreateDevice.routeName,
    );
  }

  void mockingAddDevice() {
    Random random = new Random();
    int id_int = random.nextInt(100);
    String id = id_int.toString();
    Device device = new Device(
        id: id, name: "test", protocol: "test", type: null, ipAddress: "test");
    setState(() {
      devices.add(device);
    });
  }

  void deleteDevice(String id) {
    setState(() {
      for (int i = 0; i < devices.length; i++) {
        if (devices[i].id == id) {
          print("Coming from main screen:");
          print("${devices[i].id}\n${devices[i].name}");
        }
      }
      devices.removeWhere((dev) => dev.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: showAppBar(),
        body: TabBarView(
          children: [
            DeviceList(devices, deleteDevice),
            PlaceList(places),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          elevation: 10,
          backgroundColor: Colors.black54,
          child: Icon(
            Icons.add,
            color: Colors.green,
          ),
          onPressed: () => startAddNewDevice(context),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
