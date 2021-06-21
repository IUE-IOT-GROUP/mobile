import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:prototype/models/device.dart';
import 'package:prototype/services/user.service.dart';
import 'devices/create_device_screen.dart';
import '../models/user.dart';
import '../widgets/device_list.dart';
import '../widgets/place_list.dart';
import 'places/create_place_screen.dart';
import '../global.dart';
import '../widgets/navDrawer.dart';

Future<User> loadUser() async {
  var url = '${Global.baseUrl}/me';
  final response = await Global.h_get(url, appendToken: true);
  if (response.statusCode == 200) {
    return User.fromJson(jsonDecode(response.body)['data']);
  } else {
    throw Exception('Failed to fetch user');
  }
}

class MainScreen extends StatefulWidget {
  static const routeName = '/main-screen';
  final String username = '';

  MainScreen();

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  late Future<User> futureUser;

  String username = '';
  String new_device_name = '';
  String new_device_ip = '';
  String new_device_type = '';
  List<Widget> widgetOptions = [];
  Future<User>? currentUserFuture;

  void onItemTapped(int index) {
    setState(() {
      Global.initialState = index;
    });
  }

  bool remember = false;
  @override
  void initState() {
    super.initState();
    currentUserFuture = fetchMe();
    // Global.getPlaces().then((value) {
    //   setState(() {});
    // });

    var devices = <Device>[];
    futureUser = loadUser();
    widgetOptions = <Widget>[
      PlaceList(),
      DeviceList(
        isGetAllDevices: true,
      ),
    ];
  }

  Future<User> fetchMe() async {
    var secureStorage = Global.secureStorage;
    var userId = await secureStorage.readSecureData(('id'));

    var user = await UserService.getUser(userId);

    return user;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        drawer: NavDrawer(),
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: FutureBuilder(
            future: currentUserFuture,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                User user = snapshot.data;
                return Text("Welcome ${user.name}");
              }
              return Container();
            },
          ),
          actions: [
            Global.isFog
                ? IconButton(
                    icon: Icon(
                      Icons.add,
                      color: Theme.of(context).accentColor,
                    ),
                    onPressed: () => Global.initialState == 0
                        ? Navigator.of(context).pushNamed(CreatePlace.routeName,
                            arguments: {"parentId": 0})
                        : Navigator.of(context)
                            .pushNamed(CreateDevice.routeName),
                  )
                : Container(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white12,
          selectedItemColor: Theme.of(context).accentColor,
          unselectedIconTheme: IconThemeData(opacity: 0.5),
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          selectedIconTheme: IconThemeData(opacity: 1),
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Places',
            ),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.monitor,
                ),
                label: 'Devices'),
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
