import 'package:flutter/material.dart';
import "../screens/create_device_screen.dart";
import "../screens/create_place_screen.dart";
import "../global.dart";

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
      backgroundColor: Global.pColor(context),
      title: Text("Welcome"),
      actions: [
        IconButton(
            icon: Icon(
              Icons.add,
              color: Global.aColor(context),
            ),
            onPressed: () => widget.selectedIndex == 0
                ? Navigator.of(context).pushNamed(CreatePlace.routeName)
                : Navigator.of(context).pushNamed(CreateDevice.routeName))
      ],
    );
  }
}
