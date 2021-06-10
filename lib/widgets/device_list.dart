import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:prototype/SecureStorage.dart';
import 'package:prototype/models/device.dart';
import 'package:prototype/screens/devices/device_item_screen.dart';
import 'package:prototype/services/device.service.dart';
import "../screens/main_screen.dart";
import "../SecureStorage.dart";
import "../global.dart";
import '../screens/devices/edit_device_screen.dart';

class DeviceList extends StatefulWidget {
  List<Device> devices;

  final int? placeId;
  final bool? isGetAllDevices;
  DeviceList(this.devices, {this.placeId = -1, this.isGetAllDevices = true});

  @override
  _DeviceListState createState() => _DeviceListState();
}

class _DeviceListState extends State<DeviceList> {
  void DeviceTapped(int? deviceId, BuildContext ctx) {
    Navigator.of(ctx).pushNamed(DeviceItemScreen.routeName,
        arguments: {"deviceId": deviceId});
  }

  Future getDevices() async {
    return widget.isGetAllDevices!
        ? DeviceService.getDevices()
        : DeviceService.getDevicesByPlace(widget.placeId!);
  }

  String decodeParams(List<String> params) {
    String retval = "";
    for (int i = 0; i < params.length; i++) {
      if (retval == "") {
        retval = "${params[i]}";
      } else {
        retval = "$retval, ${params[i]}";
      }
    }
    return retval;
  }

  @override
  void initState() {
    super.initState();

    future = getDevices();
  }

  void refreshScreen() async {
    CircularProgressIndicator();
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
                        List<String> paramNames = [];
                        _devices[index].parameters!.forEach((element) {
                          paramNames.add(element.optName!);
                        });
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Name:",
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Params:",
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _devices[index].name!.length <= 15
                                      ? Text(
                                          _devices[index].name!,
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      : Text(
                                          _devices[index].name!,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "${decodeParams(paramNames)}",
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            decodeParams(paramNames).length <=
                                                    25
                                                ? 14
                                                : 12),
                                  ),
                                ],
                              ),
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
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text("WARNING!"),
                                              content: SingleChildScrollView(
                                                child: ListBody(
                                                  children: <Widget>[
                                                    Text("Are you sure?")
                                                  ],
                                                ),
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: Text(
                                                    'YES',
                                                    style: TextStyle(
                                                        color: Colors.green),
                                                  ),
                                                  onPressed: () async {
                                                    bool deleteSuccess =
                                                        await DeviceService
                                                            .deleteDevice(
                                                                _devices[index]
                                                                    .id);
                                                    if (deleteSuccess) {
                                                      Navigator.of(context)
                                                          .pop();
                                                      Navigator.of(context)
                                                          .popAndPushNamed(
                                                              MainScreen
                                                                  .routeName);
                                                    } else
                                                      Global.alert(
                                                          context,
                                                          "ERROR!",
                                                          "An error has occured!");
                                                  },
                                                ),
                                                TextButton(
                                                  child: Text(
                                                    'NO',
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  ),
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(),
                                                ),
                                              ],
                                            );
                                          });

                                      refreshScreen();
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
