import 'package:flutter/material.dart';
import "../models/place.dart";

class PlaceItem extends StatelessWidget {
  final Place place;

  PlaceItem(this.place);

  void selectPlace(BuildContext ctx) {}
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
      ),
      child: InkWell(
        onTap: () => selectPlace(context),
        splashColor: Colors.grey,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
            place.name,
          ),
        ),
      ),
    );
  }
}
