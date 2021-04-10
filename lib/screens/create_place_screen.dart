import 'package:flutter/material.dart';
import 'package:prototype/dummy_data.dart';
import 'package:prototype/models/place.dart';
import 'package:prototype/screens/main_screen.dart';

class CreatePlace extends StatefulWidget {
  static const routeName = "/create-place";

  @override
  _CreatePlaceState createState() => _CreatePlaceState();
}

class _CreatePlaceState extends State<CreatePlace> {
  var nameController = TextEditingController();
  List<Place> places = DUMMY_PLACES;

  @override
  Widget build(BuildContext context) {
    Place? selectedPlace = places[0];
    final mq = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(right: 5, left: 5, top: 20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2),
              ),
              height: mq.height * 0.25,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.home,
                    size: 100,
                    color: Colors.black,
                  ),
                  Text(
                    "Add Place",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                    fit: FlexFit.tight,
                    child: Text("Name: ",
                        style: TextStyle(
                          fontSize: 25,
                        ))),
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Container(),
                ),
                Container(
                  width: mq.width * 0.4,
                  child: Flexible(
                    flex: 5,
                    fit: FlexFit.tight,
                    child: Container(
                      padding: EdgeInsets.only(top: 5),
                      child: TextField(
                        controller: nameController,
                        style: TextStyle(
                          fontSize: 23,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  child: Text(
                    "Parent: ",
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Container(),
                ),
                Container(
                  width: mq.width * 0.4,
                  child: Flexible(
                    flex: 5,
                    fit: FlexFit.tight,
                    child: Container(
                      padding: EdgeInsets.only(top: 5),
                      child: DropdownButton<Place>(
                        value: selectedPlace,
                        onChanged: (Place? newVal) {
                          setState(() {
                            selectedPlace = newVal;
                          });
                        },
                        items: places.map((Place place) {
                          return DropdownMenuItem<Place>(
                            value: place,
                            child: Text(place.name),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //secure storage
          Navigator.of(context).pop(false);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
