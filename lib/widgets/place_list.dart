import 'package:flutter/material.dart';
import 'package:prototype/services/place.service.dart';
import '../global.dart';
import "../models/place.dart";
import "./place_item.dart";

class PlaceList extends StatefulWidget {
  @override
  _PlaceListState createState() => _PlaceListState();
}

class _PlaceListState extends State<PlaceList> {
  late Future<List<dynamic>> places;

  @override
  void initState() {
    super.initState();
    Global.showCircularProgress();
    places = PlaceService.getPlaces();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: places,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          List<Place> _places = snapshot.data;
          print(_places.first.places);

          return GridView(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
            padding: const EdgeInsets.all(25),
            children: _places.map((data) => PlaceItem(data)).toList(),
          );
        }

        return CircularProgressIndicator();
      },
    );
  }
}
