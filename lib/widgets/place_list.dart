import 'package:flutter/material.dart';
import "../models/place.dart";
import "./place_item.dart";

class PlaceList extends StatelessWidget {
  List<Place> places;

  PlaceList(this.places);

  @override
  Widget build(BuildContext context) {
    return GridView(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      padding: const EdgeInsets.all(25),
      children: places.map((data) => PlaceItem(data)).toList(),
    );
  }
}
