import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:prototype/models/device_data.dart';
import 'LineTitles.dart';
import "dart:math";

class GraphMonthly extends StatefulWidget {
  List<DeviceData> data;
  GraphMonthly(this.data, this.max, this.min);
  final double min;
  final double max;
  @override
  _GraphMonthlyState createState() => _GraphMonthlyState();
}

class _GraphMonthlyState extends State<GraphMonthly> {
  @override
  Widget build(BuildContext context) {
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
      var x_d = DateTime.fromMillisecondsSinceEpoch(x.toInt()).day;
      var x_mn = DateTime.fromMillisecondsSinceEpoch(x.toInt()).month;

      var real_x = x_mn - 1 + x_d / 30 + x_h / 720;
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
        maxX: 11,
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: SideTitles(
            getTitles: (val) {
              switch (val.toInt()) {
                case 0:
                  return "JAN";
                case 1:
                  return "FEB";
                case 2:
                  return "MAR";
                case 3:
                  return "APR";
                case 4:
                  return "MAY";
                case 5:
                  return "JUN";
                case 6:
                  return "JLY";
                case 7:
                  return "AUG";
                case 8:
                  return "SEP";
                case 9:
                  return "OCT";
                case 10:
                  return "NOV";
                case 11:
                  return "DEC";
              }
              return "";
            },
            showTitles: true,
            reservedSize: 35,
            getTextStyles: (value) => const TextStyle(
              color: Color(0xff68737d),
              fontWeight: FontWeight.bold,
              fontSize: 10,
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
