import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:prototype/dummy_data.dart';
import 'package:prototype/models/place.dart';
import 'package:prototype/screens/main_screen.dart';
import 'package:prototype/services/place.service.dart';
import '../global.dart';
import 'package:http/http.dart' as http;
import "../services/place.service.dart";

class CreatePlace extends StatefulWidget {
  static const routeName = "/create-place";

  @override
  _CreatePlaceState createState() => _CreatePlaceState();
}

class _CreatePlaceState extends State<CreatePlace> {
  var nameController = TextEditingController();
  late Future<List<Place>>? places;

  @override
  void initState() {
    super.initState();
    places = PlaceService.getPlaces();
  }

  static List<String>? beforePlaceNames = ["<none>"];
  static String selectedPlace = beforePlaceNames![0];
  @override
  Widget build(BuildContext context) {
    //String? selectedPlace = places![0].name;

    final mq = MediaQuery.of(context).size;
    return FutureBuilder(
      future: places,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          final List<Place> localPlaces = snapshot.data;

          for (int i = 0; i < localPlaces.length; i++) {
            beforePlaceNames!.add(localPlaces[i].name!);
          }
          final placeNames = beforePlaceNames!.toSet().toList();

          return Scaffold(
            backgroundColor: Theme.of(context).primaryColor,
            appBar: AppBar(
              backgroundColor: Theme.of(context).primaryColor,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Theme.of(context).accentColor,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: SingleChildScrollView(
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
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Flexible(
                            flex: 3,
                            child: Text("Name: ",
                                style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                  fontSize: 25,
                                ))),
                        Flexible(
                          flex: 3,
                          fit: FlexFit.tight,
                          child: Container(),
                        ),
                        Flexible(
                          flex: 4,
                          fit: FlexFit.tight,
                          child: Container(
                            padding: EdgeInsets.only(top: 5),
                            child: TextField(
                              controller: nameController,
                              style: TextStyle(
                                color: Theme.of(context).accentColor,
                                fontSize: 23,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Flexible(
                          flex: 3,
                          child: Text(
                            "Parent: ",
                            style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 25,
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 3,
                          fit: FlexFit.tight,
                          child: Container(),
                        ),
                        Flexible(
                          flex: 4,
                          fit: FlexFit.tight,
                          child: Container(
                            padding: EdgeInsets.only(top: 5),
                            child: DropdownButton<String>(
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
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                int? parent;
                if (selectedPlace == "<none>")
                  parent = 0;
                else {
                  for (int i = 0; i < localPlaces.length; i++) {
                    if (localPlaces[i].name == selectedPlace) {
                      parent = localPlaces[i].id;
                    }
                  }
                }
                print("316$parent");
                var body = {
                  "name": nameController.text,
                  "parent": parent == 0 ? null : parent
                };
                bool response = await PlaceService.postPlace(body);
                if (response)
                  Navigator.of(context).pushNamed(MainScreen.routeName);
                else {
                  Global.warning(
                      context, "Something went wrong. Failed to add device.");
                }
              },
              child: Icon(Icons.add),
              backgroundColor: Colors.green,
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
