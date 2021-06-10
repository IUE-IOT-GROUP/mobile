import 'package:flutter/material.dart';
import 'package:prototype/models/device_data_type.dart';
import 'package:prototype/widgets/custom%20device%20items/graph_monthly.dart';
import 'package:prototype/widgets/custom%20device%20items/graph_weekly.dart';
import 'graph_daily.dart';
import 'LineTitles.dart';

enum timeInterval {
  daily,
  weekly,
  monthly,
}

class ParameterItem extends StatefulWidget {
  DeviceDataType dataType;
  String? time;

  // double temperature;
  ParameterItem(this.dataType, this.time);

  @override
  _ParameterItemState createState() => _ParameterItemState();
}

class _ParameterItemState extends State<ParameterItem> {
  String parseUnit(String unit) {
    switch (unit) {
      case "percent":
        return "%";
      case "centigrate":
        return "°C";
      case "centigratee":
        return "°C";
      default:
        return "";
    }
  }

  void rebuildAllChildren(BuildContext context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }

    (context as Element).visitChildren(rebuild);
  }

  @override
  Widget build(BuildContext context) {
    Widget? graphWidget;
    if (widget.time == "daily" || widget.time == null) {
      graphWidget = GraphDaily(
          widget.dataType.data!, widget.dataType.max!, widget.dataType.min!);
    } else if (widget.time == "weekly") {
      graphWidget = GraphWeekly(
          widget.dataType.data!, widget.dataType.max!, widget.dataType.min!);
    } else if (widget.time == "monthly") {
      graphWidget = GraphMonthly(
          widget.dataType.data!, widget.dataType.max!, widget.dataType.min!);
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
          decoration: BoxDecoration(
              color: Theme.of(context).accentColor,
              borderRadius: BorderRadius.circular(15)),
          child: Center(
            child: Text(
              "${widget.dataType.data!.first.value}${parseUnit(widget.dataType.unit!)}",
              style: TextStyle(
                  fontSize: mq.height * 0.1,
                  fontFamily: "Temperature",
                  color: Theme.of(context).primaryColor),
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
                onPressed: () {
                  setState(() {
                    widget.time = "daily";
                    rebuildAllChildren(context);
                  });
                },
                child: Text("Daily")),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    widget.time = "weekly";
                  });
                },
                child: Text("Weekly")),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    widget.time = "monthly";
                  });
                },
                child: Text("Monthly")),
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
            child: graphWidget,
          ),
        ),
        Divider(color: Theme.of(context).accentColor),
      ],
    );
  }
}
