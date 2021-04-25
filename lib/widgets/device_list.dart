import 'package:flutter/material.dart';
import 'package:prototype/SecureStorage.dart';
import 'package:prototype/models/device.dart';
import 'package:prototype/screens/device_item_screen.dart';
import "../screens/main_screen.dart";
import "../SecureStorage.dart";

class DeviceList extends StatelessWidget {
  final List<Device> devices;
  final Function removeDevice;
  SecureStorage secureStorage = SecureStorage();
  DeviceList(this.devices, this.removeDevice);
  void DeviceTapped(int? deviceId, BuildContext ctx) {
    secureStorage.writeSecureData("device id", deviceId.toString());
    Navigator.of(ctx).pushNamed(
      DeviceItemScreen.routeName,
    );
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    return Container(
      height: 100,
      // mq.size.height -
      //     MainScreen.showAppBar("name").preferredSize.height -
      //     mq.padding.top
      child: ListView.builder(
          itemCount: devices.length,
          itemExtent: 100,
          itemBuilder: (ctx, index) {
            return Card(
              elevation: 5,
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
              child: ListTile(
                onTap: () => DeviceTapped(devices[index].id, context),
                leading: Icon(
                  Icons.monitor,
                  size: 50,
                ),
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Name: ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(devices[index].name!),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Place: ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text("Some Place")
                      ],
                    ),
                  ],
                ),
                trailing: FittedBox(
                  child: Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue, size: 45),
                        onPressed: () {},
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red, size: 45),
                        onPressed: () {
                          print("index coming from list:$index");
                          print("id coming from list:${devices[index].id}");
                          removeDevice(devices[index].id);
                        },
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
