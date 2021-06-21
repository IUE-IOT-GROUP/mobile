import 'package:flutter/material.dart';
import 'package:prototype/screens/login_screen.dart';
import '../screens/main_screen.dart';
import '../screens/settings_screen.dart';
import '../widgets/themeChange.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavDrawer extends StatefulWidget {
  @override
  _NavDrawerState createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  String dark = 'Dark';
  String light = 'Light';
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Theme.of(context).primaryColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.6,
              child: ListView(padding: EdgeInsets.zero, children: [
                Container(
                  height: 200,
                  child: DrawerHeader(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      image: DecorationImage(
                        fit: BoxFit.fitWidth,
                        image: AssetImage('assets/images/iotms.png'),
                      ),
                    ),
                    child: Text(
                      '',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                ),
                ListTile(
                  leading: IconButton(
                    icon: Icon(Icons.home),
                    onPressed: () => Navigator.of(context).pushNamed(MainScreen.routeName),
                    color: Theme.of(context).accentColor,
                  ),
                  title: Text(
                    'Home',
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  onTap: () => {},
                ),
                ListTile(
                  leading: Icon(
                    Icons.settings,
                    color: Theme.of(context).accentColor,
                  ),
                  title: Text(
                    'Settings',
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  onTap: () => Navigator.of(context).pushNamed(SettingsScreen.routeName),
                ),
                ListTile(
                  leading: Icon(
                    Icons.help,
                    color: Theme.of(context).accentColor,
                  ),
                  title: Text(
                    'Help',
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  onTap: () => {Navigator.of(context).pop()},
                ),
                ListTile(
                  leading: Icon(
                    Icons.exit_to_app,
                    color: Theme.of(context).accentColor,
                  ),
                  title: Text(
                    'Logout',
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  onTap: () async {
                    var prefs = await SharedPreferences.getInstance();
                    await prefs.remove('email');
                    await prefs.remove('password');
                    await prefs.remove('rememberMe');
                    await Navigator.of(context).pushNamedAndRemoveUntil(LoginScreen.routeName, (Route<dynamic> route) => false);
                  },
                ),
              ]),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.1,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Row(
                      children: [
                        Text(
                          'Theme: ',
                          style: TextStyle(color: Theme.of(context).accentColor),
                        ),
                        Text(
                          '${ThemeChange.of(context).isDark ? dark : light}',
                          style: TextStyle(color: Theme.of(context).accentColor),
                        )
                      ],
                    ),
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Icon(
                        Icons.wb_sunny,
                        color: Theme.of(context).accentColor,
                      ),
                      Switch(
                          value: ThemeChange.of(context).isDark,
                          onChanged: (data) {
                            setState(() {
                              ThemeChange.of(context).changeColor();
                            });
                          }),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Image.asset(
                          'assets/images/dark.png',
                          fit: BoxFit.cover,
                          color: Theme.of(context).accentColor,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
