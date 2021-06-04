import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:prototype/SecureStorage.dart';
import 'package:prototype/screens/main_screen.dart';
import 'package:prototype/services/device.service.dart';
import "../models/place.dart";
import "../services/place.service.dart";
import "../global.dart";
import '../models/device.dart';
import "../models/parameter.dart";

class CreateDevice extends StatefulWidget {
  static String routeName = "/create-device";

  @override
  _CreateDeviceState createState() => _CreateDeviceState();
}

class _CreateDeviceState extends State<CreateDevice> {
  var deviceNameController = TextEditingController();
  var macAddressController = TextEditingController();
  var ipAddressController = TextEditingController();
  var paramsOptNameController = TextEditingController();
  var paramsNameController = TextEditingController();
  var paramsUnitController = TextEditingController();

  late Future<List<Place>>? places;
  List<Parameter> parameters = [];

  static List<String>? beforePlaceNames = ["-Select a place-"];
  static late List<Place>? afterPlaceNames;
  static String selectedPlace = beforePlaceNames![0];
  @override
  void initState() {
    super.initState();
    places = PlaceService.getPlaces();
  }

  void addDevice() async {
    print("316 button pressed");
    String name = deviceNameController.text;
    String ip = ipAddressController.text;
    String mac = macAddressController.text;
    late int? placeId;
    await PlaceService.getChildPlaces().then((value) {
      print("316 $value");
      value.forEach((element) {
        if (element.name == selectedPlace) placeId = element.id;
      });
    });
    print("316 3 $placeId");

    if (name.isEmpty || ip.isEmpty || mac.isEmpty) {
      Global.warning(context, "All fields must be filled!");
    } else {
      if (selectedPlace == "-Select a place-") {
        Global.warning(context, "Please select a place");
      } else {
        var params = {};
        parameters.forEach((element) {
          params[element.optName] = {
            "name": element.name,
            "unit": element.unit
          };
        });
        var body = {
          "place_id": placeId,
          "mac_address": mac,
          "ip_address": ip,
          "name": name,
          "parameters": params
        };
        print("316 Im here");
        print("316$placeId");
        bool response = await DeviceService.postDevice(body);
        print("316$response");
        if (response)
          Navigator.of(context).pushNamed(MainScreen.routeName);
        else {
          Global.warning(
              context, "Something went wrong. Failed to add device.");
        }
      }
    }
  }

  var ipFormatter = new MaskTextInputFormatter(
      mask: "###.###.#.##", filter: {"#": RegExp(r'^[0-9]')});
  var macFormatter = new MaskTextInputFormatter(
      mask: "##:##:##:##:##:##", filter: {"#": RegExp(r'^[a-fA-F0-9]')});
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    Color textFieldColor =
        Theme.of(context).primaryColor == Color.fromRGBO(17, 24, 39, 1)
            ? Color.fromRGBO(255, 255, 255, .02)
            : Color.fromRGBO(220, 220, 220, .02);
    Color hintColor =
        Theme.of(context).primaryColor == Color.fromRGBO(17, 24, 39, 1)
            ? Colors.white12
            : Colors.black12;
    return FutureBuilder(
      future: places,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Theme.of(context).primaryColor,
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: Container(
              margin: EdgeInsets.all(10),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      "Device Information",
                      style: TextStyle(
                          color: Theme.of(context).accentColor, fontSize: 20),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: 15,
                    ),
                    height: mq.height * 0.04,
                    width: mq.width * 0.7,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Theme.of(context).accentColor, width: 0.5),
                      borderRadius: BorderRadius.circular(10),
                      color: textFieldColor,
                    ),
                    child: Container(
                      padding:
                          EdgeInsets.only(top: 5, bottom: 2, right: 2, left: 2),
                      child: TextField(
                        textAlign: TextAlign.center,
                        decoration: InputDecoration.collapsed(
                            hintText: "Name",
                            hintStyle: TextStyle(color: hintColor)),
                        controller: deviceNameController,
                        style: TextStyle(
                            color: Theme.of(context).accentColor, fontSize: 20),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: 15,
                    ),
                    height: mq.height * 0.04,
                    width: mq.width * 0.7,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Theme.of(context).accentColor, width: 0.5),
                      borderRadius: BorderRadius.circular(10),
                      color: textFieldColor,
                    ),
                    child: Container(
                      padding:
                          EdgeInsets.only(top: 5, bottom: 2, right: 2, left: 2),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        inputFormatters: [ipFormatter],
                        decoration: InputDecoration.collapsed(
                            hintText: "IP Address(ex: 192.168.0.1)",
                            hintStyle: TextStyle(color: hintColor)),
                        controller: ipAddressController,
                        style: TextStyle(
                            color: Theme.of(context).accentColor, fontSize: 20),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 15, bottom: 15),
                    height: mq.height * 0.04,
                    width: mq.width * 0.7,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Theme.of(context).accentColor, width: 0.5),
                      borderRadius: BorderRadius.circular(10),
                      color: textFieldColor,
                    ),
                    child: Container(
                      padding:
                          EdgeInsets.only(top: 5, bottom: 2, right: 2, left: 2),
                      child: TextField(
                        textAlign: TextAlign.center,
                        inputFormatters: [macFormatter],
                        decoration: InputDecoration.collapsed(
                            hintText: "MAC(ex: xx:xx:xx:xx:xx:xx)",
                            hintStyle: TextStyle(color: hintColor)),
                        controller: macAddressController,
                        style: TextStyle(
                            color: Theme.of(context).accentColor, fontSize: 20),
                      ),
                    ),
                  ),
                  FutureBuilder(
                    future: places,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        final List<Place> localPlaces = snapshot.data;
                        afterPlaceNames = localPlaces;
                        List<Place> childPlaces = [];
                        afterPlaceNames!.forEach((element) {
                          if (element.places!.isNotEmpty) {
                            for (int i = 0; i < element.places!.length; i++) {
                              print("366${element.places![i].name}");
                              childPlaces.add(element.places![i]);
                            }
                          }
                        });
                        childPlaces.forEach((element) {
                          beforePlaceNames!.add(element.name!);
                        });
                        beforePlaceNames = beforePlaceNames!.toSet().toList();
                        return DropdownButton<String>(
                          value: selectedPlace,
                          items: beforePlaceNames!
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(
                                    color: Theme.of(context).accentColor),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedPlace = newValue!;
                            });
                          },
                        );
                      }
                      return CircularProgressIndicator();
                    },
                  ),
                  Divider(
                    color: Theme.of(context).accentColor,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Parameters",
                        style: TextStyle(
                            color: Theme.of(context).accentColor, fontSize: 20),
                      ),
                      IconButton(
                          icon: Icon(
                            Icons.add,
                            color: Theme.of(context).accentColor,
                          ),
                          onPressed: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (ctx) {
                                  return Container(
                                    height: mq.height * 0.3,
                                    child: Column(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(top: 20),
                                          height: mq.height * 0.04,
                                          width: mq.width * 0.6,
                                          decoration: BoxDecoration(
                                            color: textFieldColor,
                                            border: Border.all(
                                                color: Theme.of(context)
                                                    .accentColor,
                                                width: 0.5),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 5,
                                                bottom: 2,
                                                right: 2,
                                                left: 2),
                                            child: TextField(
                                              textAlign: TextAlign.center,
                                              decoration: InputDecoration.collapsed(
                                                  hintText:
                                                      "Name to be displayed(opt.)",
                                                  hintStyle: TextStyle(
                                                      color: hintColor)),
                                              controller:
                                                  paramsOptNameController,
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .accentColor,
                                                  fontSize: 17),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 20),
                                          height: mq.height * 0.04,
                                          width: mq.width * 0.6,
                                          decoration: BoxDecoration(
                                            color: textFieldColor,
                                            border: Border.all(
                                                color: Theme.of(context)
                                                    .accentColor,
                                                width: 0.5),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 5,
                                                bottom: 2,
                                                right: 2,
                                                left: 2),
                                            child: TextField(
                                              textAlign: TextAlign.center,
                                              decoration:
                                                  InputDecoration.collapsed(
                                                      hintText:
                                                          "Parameter name",
                                                      hintStyle: TextStyle(
                                                          color: hintColor)),
                                              controller: paramsNameController,
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .accentColor,
                                                  fontSize: 17),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: 20, bottom: 15),
                                          height: mq.height * 0.04,
                                          width: mq.width * 0.6,
                                          decoration: BoxDecoration(
                                            color: textFieldColor,
                                            border: Border.all(
                                                color: Theme.of(context)
                                                    .accentColor,
                                                width: 0.5),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Row(
                                            children: [
                                              Flexible(
                                                flex: 500,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5,
                                                          bottom: 2,
                                                          right: 2,
                                                          left: 2),
                                                  child: TextField(
                                                    textAlign: TextAlign.center,
                                                    decoration: InputDecoration
                                                        .collapsed(
                                                            hintText:
                                                                "Parameter unit(max 3 chars)",
                                                            hintStyle: TextStyle(
                                                                color:
                                                                    hintColor)),
                                                    controller:
                                                        paramsUnitController,
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .accentColor,
                                                        fontSize: 17),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        IconButton(
                                            icon: Icon(
                                              Icons.add,
                                              color:
                                                  Theme.of(context).accentColor,
                                            ),
                                            onPressed: () {
                                              print("267");
                                              String optName =
                                                  paramsOptNameController.text;
                                              String name =
                                                  paramsNameController.text;
                                              String unit =
                                                  paramsUnitController.text;
                                              if (name.isNotEmpty &&
                                                  unit.isNotEmpty) {
                                                if (optName.isEmpty)
                                                  optName = name;
                                                Parameter parameter =
                                                    new Parameter(
                                                        optName: optName,
                                                        name: name,
                                                        unit: unit);
                                                paramsOptNameController.text =
                                                    "";
                                                paramsNameController.text = "";
                                                paramsUnitController.text = "";
                                                setState(() {
                                                  parameters.add(parameter);
                                                });
                                                Navigator.of(ctx).pop();
                                              } else {
                                                Global.warning(context,
                                                    "You must fill the required fields!");
                                              }
                                            }),
                                      ],
                                    ),
                                  );
                                });
                          }),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    width: mq.width * 0.9,
                    height: mq.height * 0.3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Card(
                      elevation: 5,
                      child: ListView.builder(
                          itemCount: parameters.length,
                          itemBuilder: (ctx, index) {
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        parameters[index].optName!,
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 15),
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(parameters[index].name!),
                                    ),
                                    Flexible(
                                        child: Text(parameters[index].unit!))
                                  ],
                                ),
                                Divider(
                                  color: Colors.black,
                                )
                              ],
                            );
                          }),
                    ),
                  ),
                  Container(
                    height: mq.height * 0.15,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: ElevatedButton(
                            child: Icon(Icons.check),
                            onPressed: addDevice,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return Center(
            child: CircularProgressIndicator(
          backgroundColor: Theme.of(context).accentColor,
        ));
      },
    );
  }
}
