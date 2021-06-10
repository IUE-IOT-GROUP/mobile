import 'dart:convert';
import 'package:flutter/material.dart';
import 'devices/create_device_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "../models/device.dart";
import "../models/place.dart";
import "../models/user.dart";
import "../widgets/device_list.dart";
import "../widgets/place_list.dart";
import "dart:math";
import 'places/create_place_screen.dart';
import 'package:http/http.dart' as http;
import '../global.dart';
import "../widgets/navDrawer.dart";
import "../widgets/custom_appbar.dart";
import "../services/device.service.dart";

Future<User> loadUser() async {
  String url = "${Global.baseUrl}/me";
  final response = await Global.h_get(url, appendToken: true);
  if (response.statusCode == 200) {
    return User.fromJson(jsonDecode(response.body)['data']);
  } else {
    throw Exception('Failed to fetch user');
  }
}

class MainScreen extends StatefulWidget {
  static const routeName = "/main-screen";
  final String username = "";

  MainScreen();

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  late Future<User> futureUser;

  String username = '';
  String new_device_name = "";
  String new_device_ip = "";
  String new_device_type = "";
  List<Widget> widgetOptions = [];

  void onItemTapped(int index) {
    setState(() {
      Global.initialState = index;
    });
  }

  bool remember = false;
  @override
  void initState() {
    super.initState();
    Global.showCircularProgress();

    // Global.getPlaces().then((value) {
    //   setState(() {});
    // });
    futureUser = loadUser();
    widgetOptions = <Widget>[
      PlaceList(),
      DeviceList(
        Global.devices,
        isGetAllDevices: true,
      ),
    ];
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

  static void deleteDevice(int id) {
    for (int i = 0; i < Global.devices.length; i++) {
      if (Global.devices[i].id == id) {
        print("Coming from main screen:");
        print("${Global.devices[i].id}\n${Global.devices[i].name}");
      }
    }
    Global.devices.removeWhere((dev) => dev.id == id);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        drawer: NavDrawer(),
        appBar: CustomAppBar(Global.initialState),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white12,
          selectedItemColor: Theme.of(context).accentColor,
          unselectedIconTheme: IconThemeData(opacity: 0.5),
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          selectedIconTheme: IconThemeData(opacity: 1),
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Places",
            ),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.monitor,
                ),
                label: "Devices"),
          ],
          currentIndex: Global.initialState,
          onTap: onItemTapped,
        ),
        body: Container(child: widgetOptions.elementAt(Global.initialState)),
        // floatingActionButton: BottomButton(
        //   createDevice: () => startAddNewDevice(context),
        //   createPlace: () => startAddNewPlace(context),
        //   tabController: _tabController,
        // ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
