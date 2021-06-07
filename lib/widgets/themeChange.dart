import 'package:flutter/material.dart';
import 'package:prototype/global.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeChange extends ChangeNotifier {
  static const PRIMARY = Color.fromRGBO(17, 24, 39, 1);
  static const ACCENT = Color.fromRGBO(235, 237, 243, 1);

  bool isDark = true;
  final SharedPreferences _prefs;

  Color primaryColor = PRIMARY;
  Color accentColor = ACCENT;

  void changeColor() {
    this.isDark = !this.isDark;

    print("themeChange ${this.isDark}");

    this.primaryColor = this.isDark ? PRIMARY : ACCENT;
    this.accentColor = this.isDark ? ACCENT : PRIMARY;
    notifyListeners();

    _prefs.setBool('isDark', this.isDark);
  }

  ThemeChange(this._prefs) {
    this.isDark = _prefs.getBool('isDark') ?? true;
    this.primaryColor = this.isDark ? PRIMARY : ACCENT;
    this.accentColor = this.isDark ? ACCENT : PRIMARY;
  }

  static ThemeChange of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<ThemeChangeProvider>();
    return provider!.controller;
  }
}

class ThemeChangeProvider extends InheritedWidget {
  const ThemeChangeProvider(
      {Key? key, required this.controller, required Widget child})
      : super(key: key, child: child);

  final ThemeChange controller;

  @override
  bool updateShouldNotify(ThemeChangeProvider old) =>
      controller != old.controller;
}
