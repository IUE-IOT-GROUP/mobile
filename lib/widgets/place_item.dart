import 'package:flutter/material.dart';
import "../models/place.dart";
import '../screens/places/place_item_screen.dart';
import "../global.dart";

class PlaceItem extends StatelessWidget {
  final Place place;

  PlaceItem(this.place);

  void selectPlace(BuildContext ctx, Place place) {
    place.deviceList!.forEach((element) {
      print("place_item-13 #${element.id} ${element.name}");
    });
    Navigator.of(ctx)
        .pushNamed(PlaceItemScreen.routeName, arguments: {"place": place});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Theme.of(context).accentColor,
            borderRadius: BorderRadius.all(Radius.circular(15))),
        child: InkWell(
          onTap: () => selectPlace(context, place),
          splashColor: Colors.grey,
          borderRadius: BorderRadius.circular(15),
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Flexible(
                child: Text(
                  place.name!,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
