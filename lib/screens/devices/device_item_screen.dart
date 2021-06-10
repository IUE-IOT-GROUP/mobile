import 'package:flutter/material.dart';
import 'package:prototype/models/device_data.dart';
import 'package:prototype/models/device_data_type.dart';
import 'package:prototype/services/device.service.dart';
import 'package:prototype/services/device_data.service.dart';
import '../../widgets/custom device items/parameter_item.dart';
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
  var deviceNameController = TextEditingController();
  var macAddressController = TextEditingController();
  var ipAddressController = TextEditingController();
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
                            style: TextStyle(
                                color: Theme.of(context).accentColor,
                                fontSize: 24),
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
                                  children: [
                                    Text(
                                      "Name: ",
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontSize: 17),
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Text(
                                      "MAC:",
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontSize: 17),
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Text(
                                      "IP: ",
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontSize: 17),
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Text(
                                      "Place: ",
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontSize: 17),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      currentDevice.name!,
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontSize: 17),
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Text(
                                      currentDevice.macAddress!,
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontSize: 17),
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Text(
                                      currentDevice.ipAddress!,
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontSize: 17),
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Text(
                                      currentDevice.place!,
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontSize: 17),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    IconButton(
                                        icon: Icon(
                                          Icons.edit,
                                          color: Theme.of(context).accentColor,
                                        ),
                                        onPressed: () {
                                          showModalBottomSheet(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return Container(
                                                  height: mq.height * 0.2,
                                                  child: Center(
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                          top: 20),
                                                      height: mq.height * 0.04,
                                                      width: mq.width * 0.6,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Theme.of(
                                                                    context)
                                                                .accentColor,
                                                            width: 0.5),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 5,
                                                                bottom: 2,
                                                                right: 2,
                                                                left: 2),
                                                        child: TextField(
                                                          textAlign:
                                                              TextAlign.center,
                                                          controller:
                                                              deviceNameController,
                                                          style: TextStyle(
                                                              color: Theme.of(
                                                                      context)
                                                                  .accentColor,
                                                              fontSize: 17),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              });
                                        }),
                                    IconButton(
                                        icon: Icon(
                                          Icons.edit,
                                          color: Theme.of(context).accentColor,
                                        ),
                                        onPressed: () => null),
                                    IconButton(
                                        icon: Icon(
                                          Icons.edit,
                                          color: Theme.of(context).accentColor,
                                        ),
                                        onPressed: () => null),
                                    IconButton(
                                        icon: Icon(
                                          Icons.edit,
                                          color: Theme.of(context).accentColor,
                                        ),
                                        onPressed: () => null),
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
