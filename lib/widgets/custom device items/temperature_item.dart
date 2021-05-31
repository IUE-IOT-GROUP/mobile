import 'package:flutter/material.dart';
import './graphs/temperature_graph.dart';
import 'LineTitles.dart';

class TemperatureItem extends StatefulWidget {
  double temperature;
  TemperatureItem(this.temperature);
  @override
  _TemperatureItemState createState() => _TemperatureItemState();
}

class _TemperatureItemState extends State<TemperatureItem> {
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Temperature",
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
                "${widget.temperature}°C",
                style: TextStyle(
                    fontSize: mq.height * 0.1,
                    fontFamily: "Temperature",
                    color: Theme.of(context).primaryColor),
              ),
            )),
        SizedBox(
          height: mq.height * 0.1,
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
            child: TemperatureGraph(),
          ),
        ),
        Divider(color: Theme.of(context).accentColor),
      ],
    );
  }
}
