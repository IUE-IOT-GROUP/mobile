import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:prototype/models/device_data.dart';
import "../LineTitles.dart";

class TemperatureGraph extends StatefulWidget {
  List<DeviceData> data;
  TemperatureGraph(this.data);
  @override
  _TemperatureGraphState createState() => _TemperatureGraphState();
}

class _TemperatureGraphState extends State<TemperatureGraph> {
  @override
  Widget build(BuildContext context) {
    LineTitles titles = new LineTitles();
    titles.setGraphType('temperature');

    Map<String, Map<String, String>> graphData = {};
    widget.data.forEach((element) {
      print("23- ${element.createdAtDate}");
      graphData[element.id.toString()] = {element.createdAt!: element.value!};
    });

    List<FlSpot> spots = graphData.entries.map((e) {
      var y =
          DateTime.parse(e.value.keys.first).millisecondsSinceEpoch.toDouble();
      var x = e.value.values.first;

      print("32- ${double.parse(e.value.values.first)}");

      return FlSpot(y, double.parse(x));
    }).toList();

    return LineChart(
      LineChartData(
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: SideTitles(
            showTitles: true,
            reservedSize: 35,
            getTextStyles: (value) => const TextStyle(
              color: Color(0xff68737d),
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
            getTitles: (value) {
              var v = DateTime.fromMicrosecondsSinceEpoch(value.toInt());
              return DateFormat.yMMMd().format(v);
            },
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
          LineChartBarData(
            spots: spots,
          ),
        ],
      ),
    );
  }
}
