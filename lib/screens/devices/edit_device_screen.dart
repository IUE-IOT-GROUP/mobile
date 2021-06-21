import 'package:flutter/material.dart';
import 'package:prototype/models/device.dart';
import 'package:prototype/models/place.dart';
import 'package:prototype/screens/main_screen.dart';
import 'package:prototype/services/device.service.dart';
import 'package:prototype/services/place.service.dart';
import 'package:prototype/widgets/navDrawer.dart';

import '../../global.dart';

class EditDeviceScreen extends StatefulWidget {
  static var routeName = '/edit-device';

  @override
  _EditDeviceScreenState createState() => _EditDeviceScreenState();
}

class _EditDeviceScreenState extends State<EditDeviceScreen> {
  TextEditingController? nameController;
  TextEditingController? ipAddressController;
  TextEditingController? macAddressController;
  Future<Device>? _device;
  Device? currDevice;

  late Future<List<Place>>? places;
  static List<String>? beforePlaceNames = [];
  static late List<Place>? afterPlaceNames;
  String? currentPlace;
  String? _deviceId;
  Future<Device> fetchDevice() async {
    var device = await DeviceService.getDeviceById(_deviceId);

    return device;
  }

  void updateDevice() async {
    var new_name = nameController!.text;
    var new_mac = ipAddressController!.text;
    var new_ip = ipAddressController!.text;
    late String? placeId;
    await PlaceService.getPlaces().then((value) {
      value.forEach((element) {
        if (element.name == currentPlace) placeId = element.id;
      });
    });
    var params = {};
    var parameters = currDevice!.parameters!;
    parameters.forEach((element) {
      params[element.expectedParameter] = {'name': element.optName, 'unit': element.unit};
    });
    var body = {'place_id': placeId, 'mac_address': new_mac, 'ip_address': new_ip, 'name': new_name, 'parameters': params};
    Center(child: CircularProgressIndicator());
    var response = await DeviceService.updateDevice(body, currDevice!.id!);
    if (response) {
      await Navigator.of(context).popAndPushNamed(MainScreen.routeName);
    } else {
      Global.warning(context, 'Something went wrong. Failed to add device.');
    }
  }

  @override
  void initState() {
    super.initState();
    places = PlaceService.getParentPlaces();
    Future.delayed(Duration.zero, () {
      setState(() {
        final routeArgs = ModalRoute.of(context)?.settings.arguments as Map<String, String?>;
        _deviceId = routeArgs['deviceId'] as String;
        _device = fetchDevice();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _device,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          Device currentDevice = snapshot.data;
          currentPlace = currentDevice.place!;
          currDevice = snapshot.data;
          nameController = TextEditingController(text: currentDevice.name);
          macAddressController = TextEditingController(text: currentDevice.macAddress);
          ipAddressController = TextEditingController(text: currentDevice.ipAddress);

          return Scaffold(
            drawer: NavDrawer(),
            backgroundColor: Theme.of(context).primaryColor,
            appBar: AppBar(
              title: Text(currentDevice.name!),
            ),
            body: Padding(
              padding: EdgeInsets.all(30),
              child: Column(
                children: [
                  TextField(
                    controller: nameController,
                    style: TextStyle(color: Theme.of(context).accentColor),
                    decoration: InputDecoration(
                      labelText: 'Name',
                      labelStyle: TextStyle(color: Theme.of(context).accentColor),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Theme.of(context).accentColor, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Theme.of(context).accentColor, width: 1),
                      ),
                      hintText: 'Enter device name',
                      hintStyle: TextStyle(color: Theme.of(context).accentColor),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: macAddressController,
                    style: TextStyle(color: Theme.of(context).accentColor),
                    decoration: InputDecoration(
                      labelText: 'MAC',
                      labelStyle: TextStyle(color: Theme.of(context).accentColor),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Theme.of(context).accentColor, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Theme.of(context).accentColor, width: 1),
                      ),
                      hintText: 'Enter MAC address',
                      hintStyle: TextStyle(color: Theme.of(context).accentColor),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: ipAddressController,
                    style: TextStyle(color: Theme.of(context).accentColor),
                    decoration: InputDecoration(
                      labelText: 'IP',
                      labelStyle: TextStyle(color: Theme.of(context).accentColor),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Theme.of(context).accentColor, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Theme.of(context).accentColor, width: 1),
                      ),
                      hintText: 'Enter IP address',
                    ),
                  ),
                  FutureBuilder(
                    future: places,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        final List<Place> localPlaces = snapshot.data;
                        afterPlaceNames = localPlaces;
                        var childPlaces = <Place>[];
                        afterPlaceNames!.forEach((element) {
                          if (element.places!.isNotEmpty) {
                            for (var i = 0; i < element.places!.length; i++) {
                              childPlaces.add(element.places![i]);
                            }
                          }
                        });
                        childPlaces.forEach((element) {
                          beforePlaceNames!.add(element.name!);
                        });
                        beforePlaceNames = beforePlaceNames!.toSet().toList();
                        return DropdownButton<String>(
                          style: TextStyle(color: Theme.of(context).accentColor),
                          dropdownColor: Colors.white,
                          value: currentPlace,
                          selectedItemBuilder: (BuildContext context) {
                            return beforePlaceNames!.map<Widget>((String item) {
                              return Center(
                                child: Text(
                                  item,
                                  style: TextStyle(fontSize: 17),
                                ),
                              );
                            }).toList();
                          },
                          items: beforePlaceNames!.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(color: Colors.black),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              currentPlace = newValue!;
                            });
                          },
                        );
                      }
                      return CircularProgressIndicator();
                    },
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(onPressed: updateDevice, child: Text('Update'))
                ],
              ),
            ),
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
