import 'dart:math';
import 'package:flutter/material.dart';
import 'package:prototype/dummy_data.dart';
import 'package:prototype/global.dart';
import 'package:prototype/models/device.dart';
import 'package:prototype/models/device_type.dart';
import 'package:prototype/screens/main_screen.dart';
import 'package:prototype/widgets/create_device_textfield.dart';
import "../models/place.dart";
import "../widgets/navDrawer.dart";
import "../services/place.service.dart";

class CreateDevice extends StatefulWidget {
  static String routeName = "/create-device";

  @override
  _CreateDeviceState createState() => _CreateDeviceState();
}

class _CreateDeviceState extends State<CreateDevice> {
  final nameController = TextEditingController();
  final macAddressController = TextEditingController();
  final ipAddressController = TextEditingController();
  late Future<List<Place>>? places;

  static List<String>? beforePlaceNames = ["<none>"];
  static String selectedPlace = beforePlaceNames![0];
  @override
  void initState() {
    super.initState();
    places = PlaceService.getPlaces();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return FutureBuilder(
      future: places,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            backgroundColor: Theme.of(context).primaryColor,
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: Container(
              margin: EdgeInsets.all(10),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(right: 5, left: 5, top: 20),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Theme.of(context).accentColor, width: 2),
                    ),
                    height: mq.height * 0.25,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.home,
                          size: 100,
                          color: Theme.of(context).accentColor,
                        ),
                        Text(
                          "Add Place",
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 3,
                        child: Text(
                          "Name: ",
                          style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 25),
                        ),
                      ),
                      Flexible(
                        child: Container(),
                        flex: 2,
                      ),
                      Flexible(
                        flex: 5,
                        child: TextField(
                          controller: nameController,
                          style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 23),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Text(
                        "Device Type: ",
                        style: TextStyle(
                            color: Theme.of(context).accentColor, fontSize: 20),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 3,
                        child: Text(
                          "MAC Address: ",
                          style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 20),
                        ),
                      ),
                      Flexible(flex: 2, child: Container()),
                      Flexible(
                          flex: 5,
                          child: TextField(
                            controller: macAddressController,
                            style: TextStyle(
                                color: Theme.of(context).accentColor,
                                fontSize: 23),
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Text(
                        "IP Address: ",
                        style: TextStyle(
                            color: Theme.of(context).accentColor, fontSize: 20),
                      ),
                      Flexible(
                        child: TextField(
                          controller: ipAddressController,
                          style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 23),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Text(
                        "Place: ",
                        style: TextStyle(
                            color: Theme.of(context).accentColor, fontSize: 20),
                      ),
                      FutureBuilder(
                        future: places,
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            final List<Place> localPlaces = snapshot.data;

                            for (int i = 0; i < localPlaces.length; i++) {
                              beforePlaceNames!.add(localPlaces[i].name!);
                            }
                            final placeNames =
                                beforePlaceNames!.toSet().toList();

                            return DropdownButton<String>(
                              value: selectedPlace,
                              items: placeNames.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedPlace = newValue!;
                                });
                              },
                            );
                          }
                          return CircularProgressIndicator();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).popAndPushNamed(MainScreen.routeName);
              },
              backgroundColor: Colors.green,
              child: Icon(
                Icons.add,
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
        }
        return Center(
            child: CircularProgressIndicator(
          backgroundColor: Theme.of(context).accentColor,
        ));
      },
    );
  }
}
