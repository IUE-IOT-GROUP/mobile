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
import "../SecureStorage.dart";
import "../widgets/bottom_button.dart";
import "../screens/create_place_screen.dart";
import 'package:http/http.dart' as http;
import '../global.dart';
import "../widgets/navDrawer.dart";

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
  int initialState;

  MainScreen(this.initialState);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  late Future<User> futureUser;

  static List<Device> devices = [];
  static List<Place> places = DUMMY_PLACES;
  final SecureStorage secureStorage = SecureStorage();
  String username = '';
  String new_device_name = "";
  String new_device_ip = "";
  String new_device_type = "";
  int selectedIndex = 0;
  static List<Widget> widgetOptions = <Widget>[
    PlaceList(places),
    DeviceList(devices, deleteDevice),
  ];

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  fetchAndAddNewDevice() async {
    String name = await secureStorage.readSecureData("new_device_name");
    String type = await secureStorage.readSecureData("new_device_type");
    String ip = await secureStorage.readSecureData("new_device_ip");
    Random random = new Random();
    final id = random.nextInt(10000);
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

  @override
  void initState() {
    super.initState();
    futureUser = loadUser();
    print("şimdi bascak");
    print(futureUser.toString());
    fetchAndAddNewDevice();
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

  static void deleteDevice(String id) {
    for (int i = 0; i < devices.length; i++) {
      if (devices[i].id == id) {
        print("Coming from main screen:");
        print("${devices[i].id}\n${devices[i].name}");
      }
    }
    devices.removeWhere((dev) => dev.id == id);
  }

  @override
  Widget build(BuildContext context) {
    var primaryColor = Theme.of(context).primaryColor;
    var accentColor = Theme.of(context).accentColor;
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: FutureBuilder<User?>(
          future: futureUser,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data != null) {
                return Text("Welcome, ${snapshot.data.name}");
              }
            }

            return CircularProgressIndicator();
          },
        ),
        actions: [
          IconButton(
              icon: Icon(
                Icons.add,
                color: accentColor,
              ),
              onPressed: () => selectedIndex == 0
                  ? Navigator.of(context).pushNamed(CreatePlace.routeName)
                  : Navigator.of(context).pushNamed(CreateDevice.routeName))
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: primaryColor,
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
        currentIndex: selectedIndex,
        onTap: onItemTapped,
      ),
      body: Container(
        child: widgetOptions.elementAt(selectedIndex),
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
