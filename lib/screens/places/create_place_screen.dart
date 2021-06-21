import 'package:flutter/material.dart';
import 'package:prototype/models/place.dart';
import 'package:prototype/screens/main_screen.dart';
import 'package:prototype/services/place.service.dart';
import '../../global.dart';
import '../../services/place.service.dart';

class CreatePlace extends StatefulWidget {
  static const routeName = "/create-place";

  @override
  _CreatePlaceState createState() => _CreatePlaceState();
}

class _CreatePlaceState extends State<CreatePlace> {
  var nameController = TextEditingController();
  int? parentPlaceId = 0;
  Future<Place?>? parentPlaceFuture;

  @override
  void initState() {
    super.initState();
    print("1");
    Future.delayed(Duration.zero, () {
      final routeArgs =
          ModalRoute.of(context)?.settings.arguments as Map<String, int?>;

      parentPlaceId = routeArgs["parentId"];

      print("parent place id: $parentPlaceId");
      if (parentPlaceId != 0) {
        parentPlaceFuture = PlaceService.getPlaceById(parentPlaceId);
        setState(() {});
      }
    });
  }

  void createPlace() async {
    var body = {"name": nameController.text, "parent": parentPlaceId};
    bool response = await PlaceService.postPlace(body);
    if (response)
      Navigator.of(context).pushNamed(MainScreen.routeName);
    else {
      Global.warning(context, "Something went wrong. Failed to add device.");
    }
  }

  @override
  Widget build(BuildContext context) {
    //String? selectedPlace = places![0].name;
    Color textFieldColor;
    if (Theme.of(context).primaryColor == Color.fromRGBO(28, 28, 46, 1)) {
      textFieldColor = Color.fromRGBO(255, 255, 255, .02);
    } else {
      textFieldColor = Color.fromRGBO(220, 220, 220, .02);
    }
    Color hintColor;
    if (Theme.of(context).primaryColor == Color.fromRGBO(28, 28, 46, 1)) {
      hintColor = Colors.white12;
    } else {
      hintColor = Colors.black12;
    }
    final mq = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text("Add Place"),
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).accentColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                textAlign: TextAlign.center,
                style: TextStyle(color: Theme.of(context).accentColor),
                controller: nameController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).accentColor)),
                  labelText: 'Name',
                  labelStyle: TextStyle(color: Theme.of(context).accentColor),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).accentColor, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).accentColor, width: 1),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              parentPlaceId != 0
                  ? FutureBuilder(
                      future: parentPlaceFuture,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        print("111");
                        if (snapshot.hasData) {
                          Place parentPlace = snapshot.data;
                          return Container(
                            height: mq.height * 0.08,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Theme.of(context).accentColor)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Text("Parent Place: ",
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontSize: 17)),
                                  Spacer(),
                                  Text(parentPlace.name!,
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontSize: 17)),
                                ],
                              ),
                            ),
                          );
                        }
                        return CircularProgressIndicator();
                      },
                    )
                  : Container(
                      height: mq.height * 0.08,
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Theme.of(context).accentColor)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text("Parent Place: ",
                                style: TextStyle(
                                    color: Theme.of(context).accentColor,
                                    fontSize: 17)),
                            Spacer(),
                            Text(
                              "None",
                              style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                  fontSize: 17),
                            ),
                          ],
                        ),
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.all(30),
                child: ElevatedButton(
                    onPressed: createPlace, child: Icon(Icons.check)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
