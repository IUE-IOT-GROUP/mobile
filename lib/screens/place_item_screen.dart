import 'package:flutter/material.dart';
import "../widgets/place_item.dart";
import "../widgets/device_list.dart";
import "../models/place.dart";

class PlaceItemScreen extends StatefulWidget {
  static const routeName = "/place-item-screen";

  @override
  _PlaceItemScreenState createState() => _PlaceItemScreenState();
}

class _PlaceItemScreenState extends State<PlaceItemScreen> {
  static Place? currentPlace;

  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context)?.settings.arguments as Map<String, Place>;
    currentPlace = routeArgs["place"] as Place;

    final mq = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: mq.width * 0.8,
            height: mq.height * 0.3,
            margin: EdgeInsets.only(
                left: mq.width * 0.1, right: mq.width * 0.1, top: mq.height * 0.04, bottom: mq.height * 0.02),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "${currentPlace!.name}",
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                ),
                Icon(
                  Icons.home,
                  size: 100,
                ),
              ],
            ),
          ),
          currentPlace!.placeList.isNotEmpty
              ? Expanded(
                  child: GridView(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 3 / 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                    ),
                    padding: const EdgeInsets.all(25),
                    children: currentPlace!.placeList.map((data) => PlaceItem(data)).toList(),
                  ),
                )
              : currentPlace!.deviceList.isNotEmpty
                  ? Container(
                      decoration: BoxDecoration(color: Colors.red),
                      height: mq.height * 0.6,
                      child: DeviceList(currentPlace!.deviceList, () => null),
                    )
                  : Container(
                      decoration: BoxDecoration(color: Colors.white),
                    )
        ],
      ),
    );
  }
}
