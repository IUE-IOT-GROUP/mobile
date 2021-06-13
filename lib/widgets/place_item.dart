import 'package:flutter/material.dart';
import "../models/place.dart";
import '../screens/places/place_item_screen.dart';
import "../global.dart";

class PlaceItem extends StatefulWidget {
  final Place place;

  PlaceItem(this.place);

  @override
  _PlaceItemState createState() => _PlaceItemState();
}

class _PlaceItemState extends State<PlaceItem> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(color: Theme.of(context).accentColor, borderRadius: BorderRadius.all(Radius.circular(15))),
        child: InkWell(
          onTap: () => {
            Navigator.of(context).pushNamed(PlaceItemScreen.routeName, arguments: {'placeId': widget.place.id})
          },
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
                  widget.place.name!,
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
