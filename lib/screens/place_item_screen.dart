import 'package:flutter/material.dart';
import 'package:prototype/widgets/navDrawer.dart';
import "../widgets/place_item.dart";
import "../widgets/device_list.dart";
import "../models/place.dart";
import "../global.dart";
import "../dummy_data.dart";
import "../screens/main_screen.dart";

class PlaceItemScreen extends StatefulWidget {
  static const routeName = "/place-item-screen";

  @override
  _PlaceItemScreenState createState() => _PlaceItemScreenState();
}

class _PlaceItemScreenState extends State<PlaceItemScreen> {
  static Place? currentPlace;
  void ensureParent() {
    AlertDialog alert = AlertDialog(
      title: Text("WARNING!"),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(
                "You are about to remove ${currentPlace!.name}. Are you sure?"),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            'YES',
            style: TextStyle(color: Colors.green),
          ),
          onPressed: () {
            places!.removeWhere((element) {
              return element.id == currentPlace!.id;
            });
            Navigator.of(context).popAndPushNamed(MainScreen.routeName);
          },
        ),
        TextButton(
          child: Text(
            'NO',
            style: TextStyle(color: Colors.red),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  void ensureChild() {
    AlertDialog alert = AlertDialog(
      title: Text("WARNING!"),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(
                "You are about to remove ${currentPlace!.name}. Are you sure?"),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            'YES',
            style: TextStyle(color: Colors.green),
          ),
          onPressed: () {
            Place? parent;
            for (int i = 0; i < places!.length; i++) {
              if (places![i].id == currentPlace!.parentId) {
                parent = places![i];
                places![i]
                    .placeList!
                    .removeWhere((element) => element.id == currentPlace!.id);
                break;
              }
            }
            Navigator.of(context).pop();
            Navigator.of(context).popAndPushNamed(PlaceItemScreen.routeName,
                arguments: {"place": parent!});
          },
        ),
        TextButton(
          child: Text(
            'NO',
            style: TextStyle(color: Colors.red),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  List<Place>? places;
  @override
  void initState() async {
    super.initState();
    places = await Global.getPlaces();
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)?.settings.arguments as Map<String, Place>;
    currentPlace = routeArgs["place"] as Place;

    final mq = MediaQuery.of(context).size;
    return Scaffold(
      drawer: currentPlace!.parentId == -1 ? NavDrawer() : null,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(255, 255, 255, .02),
        leading: currentPlace!.parentId != -1
            ? IconButton(
                icon: Icon(Icons.arrow_back),
                color: Theme.of(context).accentColor,
                onPressed: () => Navigator.of(context).pop(),
              )
            : null,
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            color: Theme.of(context).accentColor,
            onPressed: () => null,
          ),
          IconButton(
              icon: Icon(Icons.delete),
              color: Colors.red,
              onPressed: currentPlace!.parentId == -1 //parent i var mı?
                  ? () {
                      //hayır
                      currentPlace!.placeList!.isEmpty
                          ? ensureParent()
                          : Global.warning(context,
                              "You can not remove a place with children. Try removing it's children first.");
                    }
                  : () {
                      ensureChild();
                    })
        ],
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        children: [
          Container(
            width: mq.width * 0.8,
            height: mq.height * 0.3,
            margin: EdgeInsets.only(
                left: mq.width * 0.1,
                right: mq.width * 0.1,
                top: mq.height * 0.04,
                bottom: mq.height * 0.02),
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).accentColor,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "${currentPlace!.name}",
                  style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 35,
                      fontWeight: FontWeight.bold),
                ),
                Icon(
                  Icons.home,
                  size: 100,
                  color: Theme.of(context).accentColor,
                ),
              ],
            ),
          ),
          currentPlace!.placeList!.isNotEmpty
              ? Expanded(
                  child: GridView(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 3 / 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                    ),
                    padding: const EdgeInsets.all(25),
                    children: currentPlace!.placeList!
                        .map((data) => PlaceItem(data))
                        .toList(),
                  ),
                )
              : Container(
                  height: mq.height * 0.5,
                  child: DeviceList(currentPlace!.deviceList!, () => null),
                )
        ],
      ),
    );
  }
}
