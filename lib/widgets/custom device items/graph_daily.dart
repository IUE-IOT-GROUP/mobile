import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:prototype/models/device_graph_data.dart';
import 'LineTitles.dart';
import "dart:math";

class GraphDaily extends StatefulWidget {
  List<DeviceGraphData> data;
  GraphDaily(this.data, this.max_y, this.min_y, this.max_x, this.min_x);
  final double? max_y;
  final double? min_y;
  final DateTime min_x;
  final DateTime max_x;
  @override
  _GraphDailyState createState() => _GraphDailyState();
}

class _GraphDailyState extends State<GraphDaily> {
  @override
  Widget build(BuildContext context) {
    var graphData = <String, Map<String, String>>{};

    widget.data.forEach((element) {
      graphData[element.createdAt.toString()] = {element.createdAt!: element.value!};
    });

    var spots = graphData.entries.map((e) {
      var x = DateTime.parse(e.value.keys.first).millisecondsSinceEpoch.toDouble();

      var y = e.value.values.first;

      return FlSpot(x, double.parse(y));
    }).toList();

    return LineChart(
      LineChartData(
        minY: (widget.min_y! - 5),
        maxY: (widget.max_y! + 5),
        minX: widget.min_x.millisecondsSinceEpoch.toDouble(),
        maxX: widget.max_x.millisecondsSinceEpoch.toDouble(),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: SideTitles(
            interval: 20000000,
            showTitles: true,
            reservedSize: 20,
            getTextStyles: (value) => const TextStyle(
              color: Color(0xff68737d),
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
            getTitles: (value) {
              return DateFormat.Hm().format(DateTime.fromMillisecondsSinceEpoch(value.toInt()));
            },
          ),
          leftTitles: SideTitles(
            interval: 5,
            showTitles: true,
            getTextStyles: (value) => const TextStyle(
              color: Color(0xff68737d),
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
            getTitles: (value) {
              if (value < widget.min_y!) return '';

              return value.toInt().toString();
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
            checkToShowVerticalLine: (val) {
              return val % 15 == 0;
            },
            checkToShowHorizontalLine: (val) {
              return val % 5 == 0;
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
          LineChartBarData(spots: spots, isCurved: true, dotData: FlDotData(show: false)),
        ],
      ),
    );
  }
}
