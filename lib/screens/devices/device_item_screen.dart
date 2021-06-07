import 'package:flutter/material.dart';
import 'package:prototype/services/device.service.dart';
import 'package:prototype/widgets/custom%20device%20items/humidity.dart';
import '../../widgets/custom device items/temperature_item.dart';
import '../../models/device.dart';
import '../../SecureStorage.dart';

class DeviceItemScreen extends StatefulWidget {
  static const routeName = "/device-item-screen";
  @override
  _DeviceItemScreenState createState() => _DeviceItemScreenState();
}

class _DeviceItemScreenState extends State<DeviceItemScreen> {
  Future? _devices;
  Future? _deviceId;
  Future<List<Device>> fetchDevices() async {
    List<Device> devices = [];

    devices = await DeviceService.getDevices();
    // devices.forEach((element) {
    //   if (element.id == device_id) {
    //     device = element;
    //   }
    // });
    print("32$devices");
    return devices;
  }

  Future<int> fetchDeviceId() async {
    SecureStorage storage = SecureStorage();
    int device_id = await storage.readSecureData("device id") as int;
    print("32$device_id");
    return device_id;
  }

  @override
  void initState() {
    super.initState();
    _devices = fetchDevices();

    _deviceId = fetchDeviceId();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text(
          "Device name",
          style: TextStyle(color: Theme.of(context).accentColor),
        ),
        backgroundColor: Color.fromRGBO(255, 255, 255, .02),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: _devices,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              List<Device> devices = snapshot.data;

              return FutureBuilder(
                future: _deviceId,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    int deviceId = snapshot.data;
                    Device currentDevice = new Device(name: "asd");
                    devices.forEach((element) {
                      if (element.id == deviceId) currentDevice = element;
                    });
                    print("74${currentDevice.name}");
                    print("74${currentDevice.macAddress}");
                    print("74${currentDevice.ipAddress}");

                    return Container(
                      padding: EdgeInsets.only(left: 10, top: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Device Information",
                            style: TextStyle(
                                color: Theme.of(context).accentColor,
                                fontSize: 24),
                          ),
                          Divider(
                            color: Theme.of(context).accentColor,
                          ),
                          GridView(
                              gridDelegate:
                                  SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            childAspectRatio: 3 / 2,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                          )),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5, left: 5),
                            child: TemperatureItem(25),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5, left: 5),
                            child: HumidityItem(50),
                          )
                        ],
                      ),
                    );
                  }
                  return CircularProgressIndicator();
                },
              );
            }
            return CircularProgressIndicator();
          },
        ),
      ),
      // TemperatureItem(25),
    );
  }
}
