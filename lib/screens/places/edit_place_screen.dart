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
  List<Place>? currentParentPlaces;
  Future<List<Place>>? parentPlaces;
  Future<Place>? place;
  String? currentParentPlace;
  int? _placeId;

  TextEditingController? nameController;

  Future<Place> fetchPlace() async {
    var place = await PlaceService.getPlaceById(_placeId);

    return place;
  }

  Future<List<Place>> fetchParentPlaces() async {
    var places = await PlaceService.getParentPlaces();

    return places;
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        final routeArgs = ModalRoute.of(context)?.settings.arguments as Map<String, int?>;
        _placeId = routeArgs['placeId'] as int;

        place = fetchPlace();
        parentPlaces = fetchParentPlaces();
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
            appBar: AppBar(
              title: Text(currentPlace.name!),
            ),
            body: Column(
              children: [
                TextField(
                  controller: nameController,
                  style: TextStyle(color: Theme.of(context).accentColor),
                  decoration: InputDecoration(
                    labelText: 'Name',
                    labelStyle: TextStyle(color: Theme.of(context).accentColor),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).accentColor, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).accentColor, width: 1),
                    ),
                    hintText: 'Enter device name',
                    hintStyle: TextStyle(color: Theme.of(context).accentColor),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                FutureBuilder(
                  future: parentPlaces,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      currentParentPlaces = snapshot.data;
                      currentParentPlaces!.forEach((element) {
                        if (element.id == currentPlace.id) {
                          currentParentPlace = element.name!;
                        }
                      });
                      var parentPlaceNames = <String>[];
                      currentParentPlaces!.forEach((element) {
                        parentPlaceNames.add(element.name!);
                      });
                      currentParentPlaces!.toSet().toList();
                      return DropdownButton<String>(
                        value: currentParentPlace,
                        items: parentPlaceNames.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(color: Theme.of(context).accentColor),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            currentParentPlace = newValue!;
                          });
                        },
                      );
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    onPressed: () async {
                      int? new_parent_id = 0;
                      currentParentPlaces!.forEach((element) {
                        if (element.name == currentParentPlace) {
                          new_parent_id = element.id;
                        }
                      });
                      var new_name = nameController!.text;
                      var body = {'name': new_name, 'parent': new_parent_id == 0 ? null : new_parent_id};
                      final response = await PlaceService.updatePlace(currentPlace.id, body);
                      if (response) {
                        Navigator.of(context).popAndPushNamed(MainScreen.routeName);
                      } else {
                        Global.warning(context, 'Something went wrong. Failed to update place');
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
