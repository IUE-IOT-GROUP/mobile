import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:prototype/dummy_data.dart';
import 'package:prototype/screens/create_device_screen.dart';
import "../models/device.dart";
import "../models/place.dart";
import "../models/device_type.dart";
import "../models/user.dart";
import "../widgets/device_list.dart";
import "../widgets/place_list.dart";
import "dart:math";
import "../screens/create_place_screen.dart";
import 'package:http/http.dart' as http;
import '../global.dart';
import "../widgets/navDrawer.dart";
import "../widgets/custom_appbar.dart";

Future<User> loadUser() async {
  String url = "${Global.baseUrl}/me";
  final response = await Global.h_get(url, appendToken: true);
  print(response.statusCode);
  print(response.body);
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
  static List<Widget> widgetOptions = <Widget>[
    PlaceList(Global.places),
    DeviceList(Global.devices, deleteDevice),
  ];

  void onItemTapped(int index) {
    setState(() {
      Global.initialState = index;
    });
  }

  @override
  void initState() {
    super.initState();
    futureUser = loadUser();
    print("şimdi bascak");
    print(futureUser.toString());
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
    var primaryColor = Theme.of(context).primaryColor;
    var accentColor = Theme.of(context).accentColor;
    return Scaffold(
      backgroundColor: Global.pColor(context),
      drawer: NavDrawer(),
      appBar: CustomAppBar(Global.initialState),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white12,
        selectedItemColor: accentColor,
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
      body: Container(
        child: widgetOptions.elementAt(Global.initialState),
      ),
      // floatingActionButton: BottomButton(
      //   createDevice: () => startAddNewDevice(context),
      //   createPlace: () => startAddNewPlace(context),
      //   tabController: _tabController,
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
