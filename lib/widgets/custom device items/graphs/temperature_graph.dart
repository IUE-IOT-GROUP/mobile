import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import "../LineTitles.dart";

class TemperatureGraph extends StatefulWidget {
  @override
  _TemperatureGraphState createState() => _TemperatureGraphState();
}

class _TemperatureGraphState extends State<TemperatureGraph> {
  @override
  Widget build(BuildContext context) {
    LineTitles titles = new LineTitles();
    titles.setGraphType('temperature');

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: 6,
        minY: 0,
        maxY: 10,
        titlesData: titles.getTitleData(),
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
            spots: [
              FlSpot(0, 3),
              FlSpot(2.6, 2),
              FlSpot(4.9, 5),
            ],
          ),
          LineChartBarData(spots: [
            FlSpot(0, 1),
            FlSpot(1, 2),
            FlSpot(2, 3),
            FlSpot(3, 4),
          ], colors: [
            Colors.yellow
          ])
        ],
      ),
    );
  }
}
