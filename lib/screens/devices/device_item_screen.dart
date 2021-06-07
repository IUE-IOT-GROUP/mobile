import 'package:flutter/material.dart';
import 'package:prototype/models/device_data.dart';
import 'package:prototype/models/device_data_type.dart';
import 'package:prototype/services/device.service.dart';
import 'package:prototype/services/device_data.service.dart';
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
  Future? _device;
  Future? _deviceData;
  int? _deviceId;

  Future<Device> fetchDevice() async {
    Device device = await DeviceService.getDeviceById(_deviceId);

    return device;
  }

  Future<List<DeviceDataType>> fetchData() async {
    List<DeviceDataType> deviceDataType =
        await DeviceDataService.getDeviceData(_deviceId);

    return deviceDataType;
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      setState(() {
        final routeArgs =
            ModalRoute.of(context)?.settings.arguments as Map<String, int?>;
        this._deviceId = routeArgs["deviceId"] as int;
        _device = fetchDevice();
        _deviceData = fetchData();
      });
    });
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
          future: _device,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              Device currentDevice = snapshot.data;

              return FutureBuilder(
                future: _deviceData,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    List<DeviceDataType> dataTypes = snapshot.data;
                    List<List<DeviceData>?> dataList = [];
                    dataTypes.forEach((element) {
                      dataList.add(element.data);
                    });
                    print("82: $dataList");
                    // Device currentDevice = new Device(name: "asd");
                    // devices.forEach((element) {
                    //   if (element.id == deviceId) currentDevice = element;
                    // });
                    print("74${currentDevice.name}");
                    print("74${currentDevice.macAddress}");
                    print("74${currentDevice.ipAddress}");

                    List<Padding> widgets = [];
                    dataTypes.forEach((element) {
                      Padding paddingWidget = Padding(
                        padding: EdgeInsets.only(top: 5, left: 5),
                        child: TemperatureItem(element),
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
                            style: TextStyle(
                                color: Theme.of(context).accentColor,
                                fontSize: 24),
                          ),
                          Divider(
                            color: Theme.of(context).accentColor,
                          ),
                          // GridView(
                          //     gridDelegate:
                          //         SliverGridDelegateWithMaxCrossAxisExtent(
                          //   maxCrossAxisExtent: 200,
                          //   childAspectRatio: 3 / 2,
                          //   crossAxisSpacing: 20,
                          //   mainAxisSpacing: 20,
                          // )),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [],
                          ),
                          Column(
                            children: widgets,
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
