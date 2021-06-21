import 'package:flutter/material.dart';
import 'package:prototype/models/place.dart';
import 'package:prototype/screens/main_screen.dart';
import 'package:prototype/services/place.service.dart';

import '../../global.dart';

class EditPlaceScreen extends StatefulWidget {
  static const routeName = '/edit-place';
  @override
  _EditPlaceScreenState createState() => _EditPlaceScreenState();
}

class _EditPlaceScreenState extends State<EditPlaceScreen> {
  List<Place>? currentPlaces;
  Future<List<Place>>? places;
  Future<Place>? place;
  String? currPlace;
  int? _placeId;

  TextEditingController? nameController;

  Future<Place> fetchPlace() async {
    var place = await PlaceService.getPlaceById(_placeId);

    return place;
  }

  Future<List<Place>> fetchParentPlaces() async {
    var places = await PlaceService.getPlaces();

    return places;
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        final routeArgs =
            ModalRoute.of(context)?.settings.arguments as Map<String, int?>;
        _placeId = routeArgs['placeId'] as int;

        place = fetchPlace();
        places = fetchParentPlaces();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: place,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          Place currentPlace = snapshot.data;

          nameController = TextEditingController(text: currentPlace.name!);
          return Scaffold(
            backgroundColor: Theme.of(context).primaryColor,
            appBar: AppBar(
              title: Text(currentPlace.name!),
            ),
            body: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  child: TextField(
                    controller: nameController,
                    style: TextStyle(color: Theme.of(context).accentColor),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      labelStyle:
                          TextStyle(color: Theme.of(context).accentColor),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).accentColor, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).accentColor, width: 1),
                      ),
                      hintText: 'Enter device name',
                      hintStyle:
                          TextStyle(color: Theme.of(context).accentColor),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                FutureBuilder(
                  future: places,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      currentPlaces = snapshot.data;
                      var dropdownlist = <String>[];
                      currentPlaces!.forEach((element) {
                        dropdownlist.add(element.name!);
                      });

                      currentPlaces!.forEach((element) {
                        if (element.id == currentPlace.id) {
                          currPlace = element.name!;
                        }
                      });
                      var parentPlaceNames = <String>[];
                      currentPlaces!.forEach((element) {
                        parentPlaceNames.add(element.name!);
                      });
                      dropdownlist += parentPlaceNames;
                      dropdownlist = dropdownlist.toSet().toList();
                      return DropdownButton<String>(
                        style: TextStyle(color: Theme.of(context).accentColor),
                        value: currPlace,
                        dropdownColor: Colors.white,
                        selectedItemBuilder: (BuildContext context) {
                          return dropdownlist.map<Widget>((String item) {
                            return Center(
                                child: Text(
                              item,
                              style: TextStyle(fontSize: 17),
                            ));
                          }).toList();
                        },
                        items: dropdownlist
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(color: Colors.black),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            currPlace = newValue!;
                          });
                        },
                      );
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () async {
                      int? new_parent_id = 0;
                      currentPlaces!.forEach((element) {
                        if (element.name == currPlace) {
                          new_parent_id = element.id;
                        }
                      });
                      var new_name = nameController!.text;
                      var body = {
                        'name': new_name,
                        'parent': new_parent_id == 0 ? null : new_parent_id
                      };
                      final response =
                          await PlaceService.updatePlace(currentPlace.id, body);
                      if (response) {
                        Navigator.of(context)
                            .popAndPushNamed(MainScreen.routeName);
                      } else {
                        Global.warning(context,
                            'Something went wrong. Failed to update place');
                      }
                    },
                    child: Text('Update'))
              ],
            ),
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
