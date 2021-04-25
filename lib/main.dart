import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prototype/screens/create_device_screen.dart';
import 'package:prototype/screens/main_screen.dart';
import 'screens/login_screen.dart';
import "screens/create_place_screen.dart";
import "screens/device_item_screen.dart";

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // listen to loading event
  bool isLoading = false;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "prototype",
      theme: ThemeData(
        primaryColor: Color.fromRGBO(31, 30, 44, 1),
        accentColor: Colors.grey,
        unselectedWidgetColor: Colors.grey,
        fontFamily: "Raleway",
      ),
      home: LoginScreen(),
      initialRoute: "/",
      routes: {
        MainScreen.routeName: (ctx) => MainScreen(0),
        CreateDevice.routeName: (ctx) => CreateDevice(),
        CreatePlace.routeName: (ctx) => CreatePlace(),
        DeviceItemScreen.routeName: (ctx) => DeviceItemScreen(),
      },
    );
  }
}
