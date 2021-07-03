import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prototype/screens/main_screen.dart';
import 'package:prototype/services/device.service.dart';
import '../../models/place.dart';
import '../../services/place.service.dart';
import '../../global.dart';
import '../../models/parameter.dart';

class CreateDevice extends StatefulWidget {
  static String routeName = '/create-device';

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

  List<Parameter> parameters = [];
  late Future<List<Place>>? places;
  static List<String>? beforePlaceNames = [];
  static late List<Place>? afterPlaceNames;
  static String selectedPlace = beforePlaceNames![0];
  @override
  void initState() {
    super.initState();
    places = PlaceService.getParentPlaces();
  }

  void addDevice() async {
    var name = deviceNameController.text;
    var ip = ipAddressController.text;
    var mac = macAddressController.text;
    late String? placeId;
    await PlaceService.getPlaces().then((value) {
      print("asd: $value");
      value.forEach((element) {
        if (element.name == selectedPlace) {
          print('entered if');
          print('Create Device 45: ${element.id}');
          placeId = element.id;
        }
      });
    });

    if (name.isEmpty || ip.isEmpty || mac.isEmpty) {
      Global.warning(context, 'All fields must be filled!');
    } else {
      if (selectedPlace == '-Select a place-') {
        Global.warning(context, 'Please select a place');
      } else {
        var params = {};
        parameters.forEach((element) {
          params[element.expectedParameter] = {
            'name': element.optName,
            'unit': element.unit
          };
        });
        var body = {
          'place_id': placeId,
          'mac_address': mac,
          'ip_address': ip,
          'name': name,
          'parameters': params
        };
        var response = await DeviceService.postDevice(body);
        if (response) {
          await Navigator.of(context).pushNamed(MainScreen.routeName);
        } else {
          Global.warning(
              context, 'Something went wrong. Failed to add device.');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    var textFieldColor =
        Theme.of(context).primaryColor == Color.fromRGBO(28, 28, 46, 1)
            ? Color.fromRGBO(255, 255, 255, .02)
            : Color.fromRGBO(220, 220, 220, .02);
    var hintColor =
        Theme.of(context).primaryColor == Color.fromRGBO(28, 28, 46, 1)
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
            body: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        'Device Information',
                        style: TextStyle(
                            color: Theme.of(context).accentColor, fontSize: 20),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: 15,
                      ),
                      height: mq.height * 0.06,
                      width: mq.width * 0.7,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Theme.of(context).accentColor, width: 0.5),
                        borderRadius: BorderRadius.circular(10),
                        color: textFieldColor,
                      ),
                      child: Container(
                        padding: EdgeInsets.only(
                            top: 5, bottom: 2, right: 2, left: 2),
                        child: TextField(
                          textAlign: TextAlign.center,
                          decoration: InputDecoration.collapsed(
                              hintText: 'Name',
                              hintStyle: TextStyle(color: hintColor)),
                          controller: deviceNameController,
                          style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 20),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: 15,
                      ),
                      height: mq.height * 0.06,
                      width: mq.width * 0.7,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Theme.of(context).accentColor, width: 0.5),
                        borderRadius: BorderRadius.circular(10),
                        color: textFieldColor,
                      ),
                      child: Container(
                        padding: EdgeInsets.only(
                            top: 5, bottom: 2, right: 2, left: 2),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration.collapsed(
                              hintText: 'IP Address',
                              hintStyle: TextStyle(color: hintColor)),
                          controller: ipAddressController,
                          style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 20),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 15, bottom: 15),
                      height: mq.height * 0.06,
                      width: mq.width * 0.7,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Theme.of(context).accentColor, width: 0.5),
                        borderRadius: BorderRadius.circular(10),
                        color: textFieldColor,
                      ),
                      child: Container(
                        padding: EdgeInsets.only(
                            top: 5, bottom: 2, right: 2, left: 2),
                        child: TextField(
                          textAlign: TextAlign.center,
                          decoration: InputDecoration.collapsed(
                              hintText: 'MAC Address',
                              hintStyle: TextStyle(color: hintColor)),
                          controller: macAddressController,
                          style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 20),
                        ),
                      ),
                    ),
                    FutureBuilder(
                      future: places,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          final List<Place> localPlaces = snapshot.data;
                          var dropdownList = <String>[];
                          localPlaces.forEach((element) {
                            dropdownList.add(element.name!);
                          });
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

                          dropdownList += beforePlaceNames!;
                          dropdownList.forEach((element) {});
                          return DropdownButton<String>(
                            style:
                                TextStyle(color: Theme.of(context).accentColor),
                            elevation: 24,
                            dropdownColor: Colors.white,
                            value: selectedPlace,
                            selectedItemBuilder: (BuildContext context) {
                              return dropdownList.map<Widget>((String item) {
                                return Center(
                                    child: Text(
                                  item,
                                  style: TextStyle(fontSize: 17),
                                ));
                              }).toList();
                            },
                            items: dropdownList
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ));
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
                          'Parameters',
                          style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 20),
                        ),
                        IconButton(
                            icon: Icon(
                              Icons.add,
                              color: Theme.of(context).accentColor,
                            ),
                            onPressed: () {
                              showModalBottomSheet(
                                  isScrollControlled: true,
                                  context: context,
                                  builder: (ctx) {
                                    return Container(
                                      height: mq.height * 0.4,
                                      child: Column(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(top: 20),
                                            height: mq.height * 0.06,
                                            width: mq.width * 0.8,
                                            decoration: BoxDecoration(
                                              color: textFieldColor,
                                              border: Border.all(
                                                  color: Colors.black,
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
                                                            'Display Name(opt.)',
                                                        hintStyle: TextStyle(
                                                            color:
                                                                Colors.grey)),
                                                controller:
                                                    paramsOptNameController,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 17),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(top: 20),
                                            height: mq.height * 0.06,
                                            width: mq.width * 0.8,
                                            decoration: BoxDecoration(
                                              color: textFieldColor,
                                              border: Border.all(
                                                  color: Colors.black,
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
                                                            'Parameter name',
                                                        hintStyle: TextStyle(
                                                            color:
                                                                Colors.grey)),
                                                controller:
                                                    paramsNameController,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 17),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                top: 20, bottom: 5),
                                            height: mq.height * 0.06,
                                            width: mq.width * 0.8,
                                            decoration: BoxDecoration(
                                              color: textFieldColor,
                                              border: Border.all(
                                                  color: Colors.black,
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
                                                      textAlign:
                                                          TextAlign.center,
                                                      decoration: InputDecoration
                                                          .collapsed(
                                                              hintText:
                                                                  'Parameter unit',
                                                              hintStyle: TextStyle(
                                                                  color: Colors
                                                                      .grey)),
                                                      controller:
                                                          paramsUnitController,
                                                      style: TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
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
                                                color: Colors.black,
                                              ),
                                              onPressed: () {
                                                var optName =
                                                    paramsOptNameController
                                                        .text;
                                                var name =
                                                    paramsNameController.text;
                                                var unit =
                                                    paramsUnitController.text;
                                                if (name.isNotEmpty &&
                                                    unit.isNotEmpty) {
                                                  if (optName.isEmpty)
                                                    optName = name;
                                                  var parameter = Parameter(
                                                      optName: optName,
                                                      expectedParameter: name,
                                                      unit: unit);
                                                  paramsOptNameController.text =
                                                      '';
                                                  paramsNameController.text =
                                                      '';
                                                  paramsUnitController.text =
                                                      '';
                                                  setState(() {
                                                    parameters.add(parameter);
                                                  });
                                                  Navigator.of(ctx).pop();
                                                } else {
                                                  Global.warning(context,
                                                      'You must fill the required fields!');
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
                                              color: Colors.black,
                                              fontSize: 15),
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(parameters[index]
                                            .expectedParameter!),
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
                              onPressed: addDevice,
                              child: Icon(Icons.check),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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
