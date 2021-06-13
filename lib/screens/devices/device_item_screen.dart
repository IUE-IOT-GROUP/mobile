import 'package:flutter/material.dart';
import 'package:prototype/models/device_data.dart';
import 'package:prototype/models/device_data_type.dart';
import 'package:prototype/models/place.dart';
import 'package:prototype/screens/devices/edit_device_screen.dart';
import 'package:prototype/services/device.service.dart';
import 'package:prototype/services/device_data.service.dart';
import 'package:prototype/services/place.service.dart';
import '../../global.dart';
import '../../widgets/custom device items/parameter_item.dart';
import '../../models/device.dart';
import '../../SecureStorage.dart';

class DeviceItemScreen extends StatefulWidget {
  static const routeName = '/device-item-screen';
  @override
  _DeviceItemScreenState createState() => _DeviceItemScreenState();
}

class _DeviceItemScreenState extends State<DeviceItemScreen> {
  Future? _deviceData;
  Future<Device>? _device;
  int? _deviceId;
  Device? currentDevice;

  Future<Device> fetchDevice() async {
    var device = await DeviceService.getDeviceById(_deviceId);

    return device;
  }

  Future<List<DeviceDataType>> fetchData(Device device, [String filter = 'daily']) async {
    var deviceDataType = await DeviceDataService.getDeviceData(device);

    return deviceDataType;
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        final routeArgs = ModalRoute.of(context)?.settings.arguments as Map<String, int?>;
        _deviceId = routeArgs['deviceId'] as int;
        _device = fetchDevice();
      });
    });
  }

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
        actions: [
          IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context).pushNamed(EditDeviceScreen.routeName, arguments: {'deviceId': _deviceId});
              }),
          IconButton(icon: Icon(Icons.refresh), onPressed: () => Navigator.of(context).popAndPushNamed(DeviceItemScreen.routeName))
        ],
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: _device,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              currentDevice = snapshot.data;

              _deviceData = fetchData(currentDevice!);

              return FutureBuilder(
                future: _deviceData,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    List<DeviceDataType> dataTypes = snapshot.data;
                    var dataList = <List<DeviceData>?>[];
                    dataTypes.forEach((element) {
                      dataList.add(element.data);
                    });

                    var widgets = <Padding>[];
                    dataTypes.forEach((element) {
                      var paddingWidget = Padding(
                        padding: EdgeInsets.only(top: 5, left: 5),
                        child: ParameterItem(element, 'daily'),
                      );
                      widgets.add(paddingWidget);
                    });

                    return Container(
                      padding: EdgeInsets.only(left: 10, top: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Name: ',
                                      style: TextStyle(color: Theme.of(context).accentColor, fontSize: 20),
                                    ),
                                    Spacer(),
                                    Text(
                                      currentDevice!.name!,
                                      style: TextStyle(color: Theme.of(context).accentColor, fontSize: 20),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "IP Address: ",
                                      style: TextStyle(color: Theme.of(context).accentColor, fontSize: 20),
                                    ),
                                    Spacer(),
                                    Text(
                                      currentDevice!.ipAddress!,
                                      style: TextStyle(color: Theme.of(context).accentColor, fontSize: 20),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "MAC Address: ",
                                      style: TextStyle(color: Theme.of(context).accentColor, fontSize: 20),
                                    ),
                                    Spacer(),
                                    Text(
                                      currentDevice!.macAddress!,
                                      style: TextStyle(color: Theme.of(context).accentColor, fontSize: 20),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Place: ",
                                      style: TextStyle(color: Theme.of(context).accentColor, fontSize: 20),
                                    ),
                                    Spacer(),
                                    Text(
                                      currentDevice!.place!,
                                      style: TextStyle(color: Theme.of(context).accentColor, fontSize: 20),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
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
