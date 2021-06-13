import 'package:flutter/material.dart';
import 'package:prototype/models/device_data_type.dart';
import 'package:prototype/services/device_data.service.dart';
import 'package:prototype/widgets/custom%20device%20items/graph_monthly.dart';
import 'package:prototype/widgets/custom%20device%20items/graph_weekly.dart';
import 'graph_daily.dart';

// ignore: must_be_immutable
class ParameterItem extends StatefulWidget {
  DeviceDataType dataType;
  String? time;
  Widget? graphWidget;
  int instate = 1;

  // double temperature;
  ParameterItem(this.dataType, this.time);

  @override
  _ParameterItemState createState() => _ParameterItemState();
}

class _ParameterItemState extends State<ParameterItem> {
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
    widget.dataType = await DeviceDataService.getDeviceDataByPeriod(widget.dataType, widget.time!);
    setState(() {});
  }

  bool isDaily = true;
  bool isWeekly = false;
  bool isMonthly = false;
  @override
  Widget build(BuildContext context) {
    if (widget.time == 'daily' || widget.time == null) {
      widget.graphWidget = GraphDaily(widget.dataType.graphData!, widget.dataType.max_y!, widget.dataType.min_y!, widget.dataType.max_x_date!, widget.dataType.min_x_date!);
    } else if (widget.time == 'weekly') {
      widget.graphWidget = GraphWeekly(widget.dataType.graphData!, widget.dataType.max_y!, widget.dataType.min_y!, widget.dataType.max_x_date!, widget.dataType.min_x_date!);
    } else if (widget.time == 'monthly') {
      widget.graphWidget = GraphMonthly(widget.dataType.graphData!, widget.dataType.max_y!, widget.dataType.min_y!, widget.dataType.max_x_date!, widget.dataType.min_x_date!);
    }

    final mq = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          widget.dataType.name!,
          style: TextStyle(color: Theme.of(context).accentColor, fontSize: 24),
        ),
        Divider(color: Theme.of(context).accentColor),
        Container(
          margin: EdgeInsets.only(top: 20),
          height: mq.height * 0.1,
          decoration: BoxDecoration(color: Theme.of(context).accentColor, borderRadius: BorderRadius.circular(15)),
          child: Center(
            child: Text(
              '${widget.dataType.data!.first.value}${parseUnit(widget.dataType.unit!)}',
              style: TextStyle(fontSize: mq.height * 0.1, fontFamily: 'Temperature', color: Theme.of(context).primaryColor),
            ),
          ),
        ),
        SizedBox(
          height: mq.height * 0.05,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(isDaily ? Colors.grey : Colors.blue),
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
                  backgroundColor: MaterialStateProperty.all<Color>(isWeekly ? Colors.grey : Colors.blue),
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
                  backgroundColor: MaterialStateProperty.all<Color>(isMonthly ? Colors.grey : Colors.blue),
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
          height: mq.height * 0.05,
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
        Divider(color: Theme.of(context).accentColor),
      ],
    );
  }
}
