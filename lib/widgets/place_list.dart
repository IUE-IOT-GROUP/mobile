import 'package:flutter/material.dart';
import 'package:prototype/services/place.service.dart';
import '../global.dart';
import "../models/place.dart";
import "./place_item.dart";
import 'dart:async';

class PlaceList extends StatefulWidget {
  @override
  _PlaceListState createState() => _PlaceListState();
}

class _PlaceListState extends State<PlaceList> {
  late Future<List<dynamic>> places;

  @override
  void initState() {
    super.initState();
    timer();
  }

  Future getTimerPlace() async {
    return PlaceService.getPlaces();
  }

  timer() {
    _future = getTimerPlace();
    Timer.periodic(Duration(seconds: 500), (timer) {
      setState(() {
        //_future = getTimerPlace();
      });
    });
  }

  Future? _future;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          List<Place> _places = snapshot.data;
          if (_places.isEmpty) {
            return LayoutBuilder(builder: (context, constrainst) {
              return Column(
                children: [
                  Center(
                    child: Container(
                      padding:
                          EdgeInsets.only(top: constrainst.maxHeight * 0.05),
                      child: Text(
                        "No places",
                        style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
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
                        "assets/images/waiting.png",
                        color: Theme.of(context).accentColor,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              );
            });
          }
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

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
