import 'package:flutter/material.dart';
import '../screens/places/create_place_screen.dart';
import "../global.dart";
import '../screens/devices/create_device_screen.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  CustomAppBar(this.selectedIndex, {Key? key})
      : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);
  @override
  final Size preferredSize; // default is 56.0

  late int selectedIndex;

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color.fromRGBO(255, 255, 255, .02),
      title: Text("Welcome"),
      actions: [
        IconButton(
            icon: Icon(
              Icons.add,
              color: Theme.of(context).accentColor,
            ),
            onPressed: () => widget.selectedIndex == 0
                ? Navigator.of(context).pushNamed(CreatePlace.routeName)
                : Navigator.of(context).pushNamed(CreateDevice.routeName))
      ],
    );
  }
}
