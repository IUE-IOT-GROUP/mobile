import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prototype/screens/create_device_screen.dart';
import 'package:prototype/screens/main_screen.dart';
import 'package:prototype/widgets/themeChange.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login_screen.dart';
import "screens/create_place_screen.dart";
import "screens/device_item_screen.dart";
import "screens/place_item_screen.dart";
import "screens/settings_screen.dart";
import "./global.dart";
import "./widgets/themeChange.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // listen to loading event
  bool isLoading = false;

  final prefs = await SharedPreferences.getInstance();
  final themeChange = ThemeChange(prefs);

  runApp(MyApp(themeChange: themeChange));
}

class MyApp extends StatelessWidget {
  final ThemeChange themeChange;

  const MyApp({Key? key, required this.themeChange}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: themeChange,
        builder: (context, child) {
          return ThemeChangeProvider(
              controller: themeChange,
              child: MaterialApp(
                  theme: _buildCurrentTheme(),
                  home: LoginScreen(),
                  initialRoute: "/",
                  routes: {
                    LoginScreen.routeName: (ctx) => LoginScreen(),
                    MainScreen.routeName: (ctx) => MainScreen(),
                    CreateDevice.routeName: (ctx) => CreateDevice(),
                    CreatePlace.routeName: (ctx) => CreatePlace(),
                    DeviceItemScreen.routeName: (ctx) => DeviceItemScreen(),
                    PlaceItemScreen.routeName: (ctx) => PlaceItemScreen(),
                    SettingsScreen.routeName: (ctx) => SettingsScreen(),
                  }));
        });
  }

  ThemeData _buildCurrentTheme() {
    return ThemeData(
        primaryColor: themeChange.primaryColor,
        accentColor: themeChange.accentColor);
  }
}
