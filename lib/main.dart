import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prototype/screens/devices/edit_device_screen.dart';
import 'package:prototype/screens/places/edit_place_screen.dart';
import 'screens/devices/create_device_screen.dart';
import 'package:prototype/screens/main_screen.dart';
import 'package:prototype/widgets/themeChange.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login_screen.dart';
import 'screens/places/create_place_screen.dart';
import 'screens/devices/device_item_screen.dart';
import 'screens/places/place_item_screen.dart';
import 'screens/settings_screen.dart';
import './global.dart';
import './widgets/themeChange.dart';
import './preferencesController.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  var connectivityResult = await (Connectivity().checkConnectivity());
  Global.isLocal = connectivityResult == ConnectivityResult.wifi;

  // listen to loading event
  var isLoading = false;

  final prefs = await SharedPreferences.getInstance();
  final themeChange = ThemeChange(prefs);
  await SharedPreferences.getInstance().then(
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
    var prefs = await SharedPreferences.getInstance();
    remember = prefs.getBool('rememberMe') ?? false;
    if (remember) {
      await Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MainScreen()));
    }
  }

  void fetchIsFog() async {
    var prefs = await SharedPreferences.getInstance();
    isFog = prefs.getBool("isFog") ?? isFog;
    print("main isFog: $isFog");
    if (!isFog) {
      Global.isFog = isFog;
    }
  }

  @override
  void initState() {
    super.initState();
    fetchIsRememberMe();
  }

  bool? isRemember() {
    return PreferecesController.sharedPreferencesInstance!
            .getBool('rememberMe') ??
        false;
  }

  late bool isFog = true;
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
                  initialRoute: '/',
                  routes: {
                    LoginScreen.routeName: (ctx) => LoginScreen(),
                    MainScreen.routeName: (ctx) => MainScreen(),
                    CreateDevice.routeName: (ctx) => CreateDevice(),
                    CreatePlace.routeName: (ctx) => CreatePlace(),
                    DeviceItemScreen.routeName: (ctx) => DeviceItemScreen(),
                    PlaceItemScreen.routeName: (ctx) => PlaceItemScreen(),
                    SettingsScreen.routeName: (ctx) => SettingsScreen(),
                    EditDeviceScreen.routeName: (ctx) => EditDeviceScreen(),
                    EditPlaceScreen.routeName: (ctx) => EditPlaceScreen(),
                  }));
        });
  }

  ThemeData _buildCurrentTheme() {
    return ThemeData(
        primaryColor: widget.themeChange.primaryColor,
        accentColor: widget.themeChange.accentColor);
  }
}
