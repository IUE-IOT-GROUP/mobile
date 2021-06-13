import 'package:flutter/material.dart';
import 'package:prototype/models/place.dart';
import 'package:prototype/widgets/place_item.dart';

class ChildPlaceList extends StatefulWidget {
  List<Place>? places;
  ChildPlaceList(this.places);

  @override
  _ChildPlaceListState createState() => _ChildPlaceListState();
}

class _ChildPlaceListState extends State<ChildPlaceList> {
  @override
  Widget build(BuildContext context) {
    return widget.places!.isEmpty
        ? LayoutBuilder(builder: (context, constrainst) {
            return Column(
              children: [
                Center(
                  child: Container(
                    padding: EdgeInsets.only(top: constrainst.maxHeight * 0.05),
                    child: Text(
                      'No places',
                      style: TextStyle(color: Theme.of(context).accentColor, fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(
                  height: constrainst.maxHeight * 0.05,
                ),
                Center(
                  child: Container(
                    height: constrainst.maxHeight * 0.5,
                    child: Image.asset(
                      'assets/images/waiting.png',
                      color: Theme.of(context).accentColor,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            );
          })
        : GridView(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
            padding: const EdgeInsets.all(25),
            children: widget.places!.map((data) => PlaceItem(data)).toList(),
          );
  }
}
