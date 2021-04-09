import 'package:flutter/material.dart';
import 'package:prototype/dummy_data.dart';
import 'package:prototype/screens/create_device_screen.dart';
import "../models/device.dart";
import "../models/place.dart";
import "../models/device_type.dart";
import "../widgets/device_list.dart";
import "../widgets/place_list.dart";
import "dart:math";
import "../SecureStorage.dart";
import "../widgets/bottom_button.dart";
import "../screens/create_place_screen.dart";

//https://stackoverflow.com/questions/53399223/flutter-different-floating-action-button-in-tabbar
//I have taken the "different FAB onPressed() function on different tabs" structure from this site.
class MainScreen extends StatefulWidget {
  static const routeName = "/main-screen";
  final String username = "";
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
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
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    _tabController!.addListener(_handleTabIndex);
  }

  @override
  void dispose() {
    _tabController!.removeListener(_handleTabIndex);
    _tabController!.dispose();
    super.dispose();
  }

  void _handleTabIndex() {
    setState(() {});
  }

  void startAddNewDevice(BuildContext ctx) {
    Navigator.of(ctx).popAndPushNamed(
      CreateDevice.routeName,
    );
  }

  void startAddNewPlace(BuildContext ctx) {
    Navigator.of(ctx).popAndPushNamed(
      CreatePlace.routeName,
    );
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
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(
                text: "Your Devices",
                icon: Icon(Icons.devices),
              ),
              Tab(
                text: "Your Places",
                icon: Icon(Icons.home),
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            DeviceList(devices, deleteDevice),
            PlaceList(places),
          ],
        ),
        floatingActionButton: BottomButton(
          createDevice: () => startAddNewDevice(context),
          createPlace: () => startAddNewPlace(context),
          tabController: _tabController,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
