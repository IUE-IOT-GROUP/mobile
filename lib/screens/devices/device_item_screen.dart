import 'package:flutter/material.dart';
import 'package:prototype/models/device_data.dart';
import 'package:prototype/models/device_data_type.dart';
import 'package:prototype/models/place.dart';
import 'package:prototype/services/device.service.dart';
import 'package:prototype/services/device_data.service.dart';
import 'package:prototype/services/place.service.dart';
import '../../global.dart';
import '../../widgets/custom device items/parameter_item.dart';
import '../../models/device.dart';
import '../../SecureStorage.dart';

class DeviceItemScreen extends StatefulWidget {
  static const routeName = "/device-item-screen";
  @override
  _DeviceItemScreenState createState() => _DeviceItemScreenState();
}

class _DeviceItemScreenState extends State<DeviceItemScreen> {
  late Future<List<Place>>? places;
  static List<String>? beforePlaceNames = [];
  static late List<Place>? afterPlaceNames;
  static String selectedPlace = beforePlaceNames![0];
  Future<Device>? _device;
  Future? _deviceData;
  int? _deviceId;
  String? _period;
  var deviceNameController = TextEditingController();
  var macAddressController = TextEditingController();
  var ipAddressController = TextEditingController();

  Future<Device> fetchDevice() async {
    Device device = await DeviceService.getDeviceById(_deviceId);

    return device;
  }

  Future<List<DeviceDataType>> fetchData(Device device, [String filter = 'daily']) async {
    List<DeviceDataType> deviceDataType = await DeviceDataService.getDeviceData(device);

    return deviceDataType;
  }

  @override
  void initState() {
    super.initState();
    places = PlaceService.getPlaces();
    Future.delayed(Duration.zero, () {
      setState(() {
        final routeArgs = ModalRoute.of(context)?.settings.arguments as Map<String, int?>;
        this._deviceId = routeArgs["deviceId"] as int;
        _device = fetchDevice();
      });
    });
  }

  bool nameEnabled = false;
  bool macEnabled = false;
  bool ipEnabled = false;
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(255, 255, 255, .02),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [IconButton(icon: Icon(Icons.refresh), onPressed: () => Navigator.of(context).popAndPushNamed(DeviceItemScreen.routeName))],
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: _device,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              Device currentDevice = snapshot.data;
              if (counter == 0) {
                deviceNameController.text = currentDevice.name!;
                macAddressController.text = currentDevice.macAddress!;
                ipAddressController.text = currentDevice.ipAddress!;
              }
              counter++;
              beforePlaceNames!.add(currentDevice.place!);
              _deviceData = fetchData(currentDevice);

              return FutureBuilder(
                future: _deviceData,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    List<DeviceDataType> dataTypes = snapshot.data;
                    List<List<DeviceData>?> dataList = [];
                    dataTypes.forEach((element) {
                      dataList.add(element.data);
                    });

                    List<Padding> widgets = [];
                    dataTypes.forEach((element) {
                      Padding paddingWidget = Padding(
                        padding: EdgeInsets.only(top: 5, left: 5),
                        child: ParameterItem(element, "daily"),
                      );
                      widgets.add(paddingWidget);
                    });

                    return Container(
                      padding: EdgeInsets.only(left: 10, top: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Device Information",
                            style: TextStyle(color: Theme.of(context).accentColor, fontSize: 24),
                          ),
                          Divider(
                            color: Theme.of(context).accentColor,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: mq.height * 0.05,
                                      width: mq.width * 0.5,
                                      child: TextFormField(
                                        style: TextStyle(color: Theme.of(context).accentColor),
                                        controller: deviceNameController,
                                        enabled: nameEnabled,
                                        decoration: InputDecoration(disabledBorder: InputBorder.none, enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Container(
                                      height: mq.height * 0.05,
                                      width: mq.width * 0.5,
                                      child: TextFormField(
                                        style: TextStyle(color: Theme.of(context).accentColor),
                                        controller: macAddressController,
                                        enabled: macEnabled,
                                        decoration: InputDecoration(disabledBorder: InputBorder.none, enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Container(
                                      height: mq.height * 0.05,
                                      width: mq.width * 0.5,
                                      child: TextFormField(
                                        style: TextStyle(color: Theme.of(context).accentColor),
                                        controller: ipAddressController,
                                        enabled: ipEnabled,
                                        decoration: InputDecoration(disabledBorder: InputBorder.none, enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30,
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
                                            items: beforePlaceNames!.map<DropdownMenuItem<String>>((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(
                                                  value,
                                                  style: TextStyle(color: Theme.of(context).accentColor),
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
                                        return Center(child: CircularProgressIndicator());
                                      },
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 18),
                                      child: IconButton(
                                          icon: Icon(
                                            Icons.edit,
                                            color: Theme.of(context).accentColor,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              nameEnabled = true;
                                            });
                                          }),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 18),
                                      child: IconButton(
                                          icon: Icon(
                                            Icons.edit,
                                            color: Theme.of(context).accentColor,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              macEnabled = true;
                                            });
                                          }),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 18),
                                      child: IconButton(
                                          icon: Icon(
                                            Icons.edit,
                                            color: Theme.of(context).accentColor,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              ipEnabled = true;
                                            });
                                          }),
                                    ),
                                    IconButton(
                                        icon: Icon(
                                          Icons.edit,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        onPressed: () => null),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                              onPressed: () async {
                                String new_name = deviceNameController.text;
                                String new_mac = macAddressController.text;
                                String new_ip = ipAddressController.text;
                                late int? placeId;
                                await PlaceService.getChildPlaces().then((value) {
                                  value.forEach((element) {
                                    if (element.name == selectedPlace) placeId = element.id;
                                  });
                                });
                                var params = {};
                                var parameters = currentDevice.parameters!;
                                parameters.forEach((element) {
                                  params[element.expectedParameter] = {"name": element.optName, "unit": element.unit};
                                });
                                var body = {"place_id": placeId, "mac_address": new_mac, "ip_address": new_ip, "name": new_name, "parameters": params};
                                Center(child: CircularProgressIndicator());
                                bool response = await DeviceService.updateDevice(body, currentDevice.id!);
                                if (response) {
                                  Global.warning(context, "Success!");
                                } else {
                                  Global.warning(context, "Something went wrong. Failed to add device.");
                                }
                              },
                              child: Text("Update")),
                          Column(
                            children: widgets,
                          )
                        ],
                      ),
                    );
                  }
                  return Center(child: CircularProgressIndicator());
                },
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
      // TemperatureItem(25),
    );
  }
}
