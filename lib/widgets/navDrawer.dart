import 'package:flutter/material.dart';
import "../global.dart";
import "../screens/main_screen.dart";
import "../screens/settings_screen.dart";

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Global.aColor(context),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text(
                'Burda logo olcak',
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
              decoration: BoxDecoration(
                color: Colors.green,
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage('assets/images/cover.jpg'),
                ),
              ),
            ),
            ListTile(
              leading: IconButton(
                icon: Icon(Icons.home),
                onPressed: () =>
                    Navigator.of(context).pushNamed(MainScreen.routeName),
                color: Global.pColor(context),
              ),
              title: Text(
                'Home',
                style: TextStyle(
                  color: Global.pColor(context),
                ),
              ),
              onTap: () => {},
            ),
            ListTile(
              leading: Icon(
                Icons.settings,
                color: Global.pColor(context),
              ),
              title: Text(
                'Settings',
                style: TextStyle(
                  color: Global.pColor(context),
                ),
              ),
              onTap: () =>
                  Navigator.of(context).pushNamed(SettingsScreen.routeName),
            ),
            ListTile(
              leading: Icon(
                Icons.people,
                color: Global.pColor(context),
              ),
              title: Text(
                'Users',
                style: TextStyle(
                  color: Global.pColor(context),
                ),
              ),
              onTap: () => {Navigator.of(context).pop()},
            ),
            ListTile(
              leading: Icon(
                Icons.help,
                color: Global.pColor(context),
              ),
              title: Text(
                'Help',
                style: TextStyle(
                  color: Global.pColor(context),
                ),
              ),
              onTap: () => {Navigator.of(context).pop()},
            ),
            ListTile(
              leading: Icon(
                Icons.exit_to_app,
                color: Global.pColor(context),
              ),
              title: Text(
                'Logout',
                style: TextStyle(
                  color: Global.pColor(context),
                ),
              ),
              onTap: () => {Navigator.of(context).pop()},
            ),
          ],
        ),
      ),
    );
  }
}
