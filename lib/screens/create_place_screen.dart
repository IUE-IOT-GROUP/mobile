import 'package:flutter/material.dart';

class CreatePlace extends StatefulWidget {
  static const routeName = "/create-place";

  @override
  _CreatePlaceState createState() => _CreatePlaceState();
}

class _CreatePlaceState extends State<CreatePlace> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Card(
      child: Text("Create Place!"),
    ));
  }
}
