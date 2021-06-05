import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:prototype/SecureStorage.dart';
import 'package:prototype/models/device.dart';
import 'package:prototype/screens/device_item_screen.dart';
import 'package:prototype/services/device.service.dart';
import "../screens/main_screen.dart";
import "../SecureStorage.dart";
import "../global.dart";
import "../screens/edit_device_screen.dart";

class DeviceList extends StatefulWidget {
  List<Device> devices;
  final Function removeDevice;
  final int? placeId;
  DeviceList(this.devices, this.removeDevice, {this.placeId = -1});

  @override
  _DeviceListState createState() => _DeviceListState();
}

class _DeviceListState extends State<DeviceList> {
  void DeviceTapped(int? deviceId, BuildContext ctx) {
    Global.secureStorage.writeSecureData("device id", deviceId.toString());
    Navigator.of(ctx).pushNamed(
      DeviceItemScreen.routeName,
    );
  }

  Future getDevices() async {
    return widget.placeId == -1
        ? null
        : DeviceService.getDevicesByPlace(widget.placeId!);
  }

  @override
  void initState() {
    super.initState();
    // Device dev = new Device(
    //     id: 1,
    //     name: "test device",
    //     ipAddress: "192.168.1.1",
    //     macAddress: "aa:aa:aa:aa:aa:aa",
    //     place: "test");
    // if (_devices.isEmpty) _devices.add(dev);
    setState(() {
      future = getDevices();
    });
  }

  Future? future;
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return FutureBuilder(
      future: future,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          List<Device> _devices = snapshot.data;

          print("62 ${_devices}");

          print("device_list-64 ${_devices.isEmpty}");

          return _devices.isNotEmpty
              ? Container(
                  height: mq.height,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                  ),
                  child: ListView.builder(
                      itemCount: _devices.length,
                      itemExtent: 100,
                      itemBuilder: (ctx, index) {
                        return Card(
                          color: Theme.of(context).accentColor,
                          elevation: 40,
                          margin:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                          child: ListTile(
                            onTap: () =>
                                DeviceTapped(_devices[index].id, context),
                            leading: Icon(
                              Icons.monitor,
                              size: 50,
                              color: Theme.of(context).primaryColor,
                            ),
                            title: Row(children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Name: ",
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        _devices[index].name!,
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Place: ",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                      Text(
                                        "Some Place",
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 40,
                              ),
                              Center(
                                  child: Text(
                                "25",
                                style: TextStyle(
                                    fontFamily: "Temperature",
                                    color: Colors.green,
                                    fontSize: 35),
                              ))
                            ]),
                            trailing: FittedBox(
                              child: Column(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit,
                                        color: Colors.blue, size: 45),
                                    onPressed: () {
                                      EditDeviceScreen();
                                    },
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete,
                                        color: Colors.red, size: 45),
                                    onPressed: () {
                                      print("index coming from list:$index");
                                      print(
                                          "id coming from list:${_devices[index].id}");
                                      WidgetsBinding.instance!
                                          .addPostFrameCallback((_) {
                                        setState(() {
                                          widget
                                              .removeDevice(_devices[index].id);
                                        });
                                      });
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                )
              : LayoutBuilder(builder: (context, constrainst) {
                  return Column(
                    children: [
                      Center(
                        child: Container(
                          padding: EdgeInsets.only(
                              top: constrainst.maxHeight * 0.05),
                          child: Text(
                            "No devices",
                            style: TextStyle(
                                color: Theme.of(context).accentColor,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: constrainst.maxHeight * 0.05,
                      ),
                      Center(
                        child: Container(
                          height: constrainst.maxHeight * 0.5,
                          child: Image.asset(
                            "assets/images/waiting.png",
                            color: Theme.of(context).accentColor,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  );
                });
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
