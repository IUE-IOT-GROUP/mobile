import 'dart:async';

import 'package:flutter/material.dart';
import 'package:prototype/models/device_data.dart';
import 'package:prototype/models/device_data_type.dart';
import 'package:prototype/screens/devices/edit_device_screen.dart';
import 'package:prototype/services/device.service.dart';
import 'package:prototype/services/device_data.service.dart';
import '../../widgets/custom device items/parameter_item.dart';
import '../../models/device.dart';
import '../../global.dart';

class DeviceItemScreen extends StatefulWidget {
  static const routeName = '/device-item-screen';
  @override
  _DeviceItemScreenState createState() => _DeviceItemScreenState();
}

class _DeviceItemScreenState extends State<DeviceItemScreen> {
  Future? _deviceData;
  Future<Device>? _device;
  String? _deviceId;
  Device? currentDevice;

  Future<Device> fetchDevice() async {
    var device = await DeviceService.getDeviceById(_deviceId);

    return device;
  }

  Future<List<DeviceDataType>> fetchData(Device device,
      [String filter = 'daily']) async {
    return DeviceDataService.getDeviceData(device);
  }

  @override
  void initState() {
    super.initState();
    Device currentDevice;
    Future.delayed(Duration.zero, () {
      setState(() {
        final routeArgs =
            ModalRoute.of(context)?.settings.arguments as Map<String, String?>;
        _deviceId = routeArgs['deviceId'] as String;
        _device = fetchDevice();
      });
    });
  }

  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: FutureBuilder(
          future: _device,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            currentDevice = snapshot.data;
            if (snapshot.hasData) {
              return Text(currentDevice!.name!);
            }
            return Container();
          },
        ),
        backgroundColor: Color.fromRGBO(255, 255, 255, .02),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Global.isFog
              ? IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.of(context).pushNamed(EditDeviceScreen.routeName,
                        arguments: {'deviceId': _deviceId});
                  })
              : Container(),
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
                        child: ParameterItem(element, 'daily', currentDevice!),
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
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'IP Address: ',
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontSize: 20),
                                    ),
                                    Spacer(),
                                    Text(
                                      currentDevice!.ipAddress!,
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontSize: 20),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'MAC Address: ',
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontSize: 20),
                                    ),
                                    Spacer(),
                                    Text(
                                      currentDevice!.macAddress!,
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontSize: 20),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Place: ',
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontSize: 20),
                                    ),
                                    Spacer(),
                                    Text(
                                      currentDevice!.place!,
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontSize: 20),
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
    );
  }
}
