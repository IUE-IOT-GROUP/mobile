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

  void fetchAndAddNewDevice(BuildContext ctx, List<Device> devices) {
    final routeArgs =
        ModalRoute.of(ctx)!.settings.arguments as Map<String, Device>;
    Device? new_device = routeArgs["device"];
    if (new_device != null) devices.add(new_device);
  }

  @override
  Widget build(BuildContext context) {
    // fetchAndAddNewDevice(context, devices);    bu satır patlatıyor
    // final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, String>;

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
          onPressed: mockingAddDevice,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
