import 'package:flutter/material.dart';
import "../models/place.dart";
import "../screens/place_item_screen.dart";
import "../global.dart";

class PlaceItem extends StatelessWidget {
  final Place place;

  PlaceItem(this.place);

  void selectPlace(BuildContext ctx, Place place) {
    Navigator.of(ctx)
        .pushNamed(PlaceItemScreen.routeName, arguments: {"place": place});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white12,
        border: Border.all(
          color: Global.aColor(context),
        ),
      ),
      child: InkWell(
        onTap: () => selectPlace(context, place),
        splashColor: Colors.grey,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                place.name,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Global.aColor(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
