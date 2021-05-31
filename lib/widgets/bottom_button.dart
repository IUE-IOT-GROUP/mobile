import 'package:flutter/material.dart';
import 'package:prototype/screens/create_place_screen.dart';
import "../screens/create_device.dart";

//https://stackoverflow.com/questions/53399223/flutter-different-floating-action-button-in-tabbar
//I have taken the "different FAB onPressed() function on different tabs" structure from this site.
class BottomButton extends StatelessWidget {
  final TabController? tabController;
  final Function? createDevice;
  final Function? createPlace;

  BottomButton({this.tabController, this.createDevice, this.createPlace});
  @override
  Widget build(BuildContext context) {
    return tabController!.index == 0
        ? FloatingActionButton(
            onPressed: () {
              createDevice!();
            },
            elevation: 10,
            backgroundColor: Colors.black54,
            child: Icon(
              Icons.add,
              size: 50,
              color: Colors.green,
            ),
          )
        : FloatingActionButton(
            onPressed: () {
              createPlace!();
            },
            elevation: 10,
            backgroundColor: Colors.black54,
            child: Icon(
              Icons.add,
              size: 50,
              color: Colors.green,
            ),
          );
  }
}
