import 'package:flutter/material.dart';
import 'package:prototype/screens/create_device_screen.dart';
import 'package:prototype/screens/main_screen.dart';
import 'screens/login_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "prototype",
      theme: ThemeData(
        primaryColor: Colors.orange,
        accentColor: Colors.black,
        unselectedWidgetColor: Colors.grey,
        fontFamily: "Raleway",
      ),
      home: LoginScreen(),
      initialRoute: "/",
      routes: {
        MainScreen.routeName: (ctx) => MainScreen(),
        CreateDevice.routeName: (ctx) => CreateDevice(),
      },
    );
  }
}
