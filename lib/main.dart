import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './screens/create_device.dart';
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
import "./preferencesController.dart";

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
  SharedPreferences.getInstance().then(
      (instance) => PreferecesController.sharedPreferencesInstance = instance);

  runApp(MyApp(themeChange: themeChange));
}

class MyApp extends StatefulWidget {
  final ThemeChange themeChange;

  MyApp({Key? key, required this.themeChange}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void fetchIsRememberMe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    remember = prefs.getBool("rememberMe") ?? false;
    print("45$remember");
    if (remember) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => new MainScreen()));
    }
  }

  @override
  void initState() {
    super.initState();
    fetchIsRememberMe();
  }

  bool? isRemember() {
    return PreferecesController.sharedPreferencesInstance!
            .getBool("rememberMe") ??
        false;
  }

  late bool remember = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: widget.themeChange,
        builder: (context, child) {
          return ThemeChangeProvider(
              controller: widget.themeChange,
              child: MaterialApp(
                  theme: _buildCurrentTheme(),
                  home: isRemember()! ? MainScreen() : LoginScreen(),
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
        primaryColor: widget.themeChange.primaryColor,
        accentColor: widget.themeChange.accentColor);
  }
}
