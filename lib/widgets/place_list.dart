import 'package:flutter/material.dart';
import "../models/place.dart";

class PlaceList extends StatelessWidget {
  final List<Place> places;

  PlaceList(this.places);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          itemCount: places.length,
          itemBuilder: (ctx, index) {
            return Card(
              elevation: 10,
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
              child: InkWell(
                child: Image.asset("assets/images/home.png"),
                onTap: () {},
              ),
            );
          }),
    );
  }
}
