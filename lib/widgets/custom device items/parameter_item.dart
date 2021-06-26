import 'dart:async';

import 'package:flutter/material.dart';
import 'package:prototype/models/device.dart';
import 'package:prototype/models/device_data_type.dart';
import 'package:prototype/services/device.service.dart';
import 'package:prototype/services/device_data.service.dart';
import 'package:prototype/widgets/custom%20device%20items/graph_monthly.dart';
import 'package:prototype/widgets/custom%20device%20items/graph_weekly.dart';
import 'graph_daily.dart';

// ignore: must_be_immutable
class ParameterItem extends StatefulWidget {
  Device currentDevice;
  DeviceDataType dataType;
  String? time;
  Widget? graphWidget;
  int instate = 1;

  // double temperature;
  ParameterItem(this.dataType, this.time, this.currentDevice);

  @override
  _ParameterItemState createState() => _ParameterItemState();
}

class _ParameterItemState extends State<ParameterItem> {
  Future? _deviceDataTypeFuture;
  DeviceDataType? currentDataType;
  Future getTimerDataType() async {
    return DeviceDataService.getDeviceDataByPeriod(
        widget.dataType, widget.time!);
  }

  void timer() {
    _deviceDataTypeFuture = getTimerDataType();
    Timer.periodic(Duration(seconds: 5), (timer) {
      _deviceDataTypeFuture = getTimerDataType();
      print('called setstate');
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    timer();
  }

  String parseUnit(String unit) {
    switch (unit) {
      case 'percent':
        return '%';
      case 'centigrate':
        return '°C';
      case 'centigratee':
        return '°C';
      default:
        return '';
    }
  }

  void fetchNewData() async {
    widget.dataType = await DeviceDataService.getDeviceDataByPeriod(
        widget.dataType, widget.time!);
    setState(() {});
  }

  bool isDaily = true;
  bool isWeekly = false;
  bool isMonthly = false;
  @override
  Widget build(BuildContext context) {
    List<String?>? lastTenValue = [];
    widget.dataType.data!.forEach((element) {
      lastTenValue.add(element.value!);
    });
    if (widget.time == 'daily' || widget.time == null) {
      widget.graphWidget = GraphDaily(
          widget.dataType.graphData!,
          widget.dataType.max_y!,
          widget.dataType.min_y!,
          widget.dataType.max_x_date!,
          widget.dataType.min_x_date!);
    } else if (widget.time == 'weekly') {
      widget.graphWidget = GraphWeekly(
          widget.dataType.graphData!,
          widget.dataType.max_y!,
          widget.dataType.min_y!,
          widget.dataType.max_x_date!,
          widget.dataType.min_x_date!);
    } else if (widget.time == 'monthly') {
      widget.graphWidget = GraphMonthly(
          widget.dataType.graphData!,
          widget.dataType.max_y!,
          widget.dataType.min_y!,
          widget.dataType.max_x_date!,
          widget.dataType.min_x_date!);
    }
    String appendText(List<String?>? values) {
      String retVal = '';
      for (int i = 0; i < values!.length; i++) {
        double.parse(values[i]!).toInt().toString();
        if (retVal == '') {
          retVal = '${values[i]}';
        } else {
          retVal = '$retVal, ${values[i]}';
        }
      }
      return retVal;
    }

    final mq = MediaQuery.of(context).size;
    return FutureBuilder(
      future: _deviceDataTypeFuture,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          currentDataType = snapshot.data;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                currentDataType!.name!,
                style: TextStyle(
                    color: Theme.of(context).accentColor, fontSize: 24),
              ),
              Divider(color: Theme.of(context).accentColor),
              Container(
                margin: EdgeInsets.only(top: 20),
                height: mq.height * 0.1,
                decoration: BoxDecoration(
                    color: Theme.of(context).accentColor,
                    borderRadius: BorderRadius.circular(15)),
                child: Center(
                  child: Text(
                    '${currentDataType!.data!.first.value}${parseUnit(currentDataType!.unit!)}',
                    style: TextStyle(
                        fontSize: mq.height * 0.1,
                        fontFamily: 'Temperature',
                        color: Theme.of(context).primaryColor),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            isDaily ? Colors.grey : Colors.blue),
                      ),
                      onPressed: () {
                        setState(() {
                          isDaily = true;
                          isWeekly = false;
                          isMonthly = false;

                          widget.time = 'daily';
                          fetchNewData();
                        });
                      },
                      child: Text('Daily')),
                  ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            isWeekly ? Colors.grey : Colors.blue),
                      ),
                      onPressed: () {
                        setState(() {
                          isDaily = false;
                          isWeekly = true;
                          isMonthly = false;
                          widget.time = 'weekly';
                          fetchNewData();
                        });
                      },
                      child: Text('Weekly')),
                  ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            isMonthly ? Colors.grey : Colors.blue),
                      ),
                      onPressed: () {
                        setState(() {
                          isDaily = false;
                          isWeekly = false;
                          isMonthly = true;
                          widget.time = 'monthly';
                          fetchNewData();
                        });
                      },
                      child: Text('Monthly')),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.only(right: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Theme.of(context).primaryColor,
                ),
                width: mq.width,
                height: mq.height * 0.4,
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: widget.graphWidget,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                ),
                width: mq.width,
                height: mq.height * 0.4,
                child: Card(
                  color: Color.fromRGBO(0, 2, 64, 1),
                  elevation: 40,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 20,
                      bottom: 5,
                      left: 20,
                    ),
                    child: isDaily == false
                        ? Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Min:',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 21,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      'Max:',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 21,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      'Avg:',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 21,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      'Std Dev:',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 21,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      'Recent:',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 21,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '27${parseUnit(currentDataType!.unit!)}',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 21,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    '40${parseUnit(currentDataType!.unit!)}',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 21,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    '33.7${parseUnit(currentDataType!.unit!)}',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 21,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    '1.37',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 21,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 21,
                                  ),
                                  Flexible(
                                    fit: FlexFit.tight,
                                    child: Text(
                                      appendText(lastTenValue),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )
                        : Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Min:',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 21,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      'Max:',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 21,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      'Avg:',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 21,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      'Recent:',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 21,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '27${parseUnit(currentDataType!.unit!)}',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 21,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    '40${parseUnit(currentDataType!.unit!)}',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 21,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    '33.7${parseUnit(currentDataType!.unit!)}',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 21,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 25,
                                  ),
                                  Text(
                                    appendText(lastTenValue),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                  ),
                ),
              ),
              Divider(color: Theme.of(context).accentColor),
            ],
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
