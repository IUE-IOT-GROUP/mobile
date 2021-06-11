import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:prototype/models/device_data.dart';
import 'LineTitles.dart';
import "dart:math";

class GraphDaily extends StatefulWidget {
  List<DeviceData> data;
  GraphDaily(this.data, this.max, this.min);
  final double min;
  final double max;
  @override
  _GraphDailyState createState() => _GraphDailyState();
}

class _GraphDailyState extends State<GraphDaily> {
  @override
  Widget build(BuildContext context) {
    // LineTitles titles = new LineTitles();
    // titles.setGraphType('temperature');

    Map<String, Map<String, String>> graphData = {};
    List<double> yValues = [];
    List<double> xValues = [];

    widget.data.forEach((element) {
      graphData[element.id.toString()] = {element.createdAt!: element.value!};
    });
    List<FlSpot> spots = graphData.entries.map((e) {
      var x =
          DateTime.parse(e.value.keys.first).millisecondsSinceEpoch.toDouble();
      var x_h = DateTime.fromMillisecondsSinceEpoch(x.toInt()).hour;
      var x_m = DateTime.fromMillisecondsSinceEpoch(x.toInt()).minute;
      var x_d = DateTime.fromMillisecondsSinceEpoch(x.toInt()).weekday;
      var x_mn = DateTime.fromMillisecondsSinceEpoch(x.toInt()).month;

      var real_x = x_h + (x_m / 60);
      var y = e.value.values.first;
      yValues.add(double.parse(y));
      xValues.add(real_x);

      return FlSpot(real_x, double.parse(y));
    }).toList();

    return LineChart(
      LineChartData(
        minY: widget.min,
        maxY: widget.max,
        minX: 0,
        maxX: 24,
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: SideTitles(
            interval: 2,
            showTitles: true,
            reservedSize: 35,
            getTextStyles: (value) => const TextStyle(
              color: Color(0xff68737d),
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          leftTitles: SideTitles(
            interval: 10,
            showTitles: true,
            getTextStyles: (value) => const TextStyle(
              color: Color(0xff68737d),
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border(
              left: BorderSide(
                color: Colors.grey,
                width: 1,
              ),
              bottom: BorderSide(
                color: Colors.grey,
                width: 1,
              )),
        ),
        gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            checkToShowVerticalLine: (val) {
              return val % 2 == 0;
            },
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey,
                strokeWidth: 0.2,
              );
            },
            getDrawingVerticalLine: (value) {
              return FlLine(color: Colors.grey, strokeWidth: 0.2);
            }),
        lineBarsData: [
          LineChartBarData(spots: spots, isCurved: true),
        ],
      ),
    );
  }
}
