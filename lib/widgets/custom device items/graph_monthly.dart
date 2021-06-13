import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:prototype/models/device_graph_data.dart';

// ignore: must_be_immutable
class GraphMonthly extends StatefulWidget {
  List<DeviceGraphData> data;
  GraphMonthly(this.data, this.max_y, this.min_y, this.max_x, this.min_x);
  final double? max_y;
  final double? min_y;
  final DateTime min_x;
  final DateTime max_x;
  @override
  _GraphMonthlyState createState() => _GraphMonthlyState();
}

class _GraphMonthlyState extends State<GraphMonthly> {
  @override
  Widget build(BuildContext context) {
    var graphData = <int, Map<int, String>>{};

    var xValues = <int, DateTime?>{};

    var i = 4;
    widget.data.forEach((element) {
      graphData[i] = {i: element.value!};
      xValues[i] = element.createdAtDate;
      i--;
    });

    var spots = graphData.entries.map((e) {
      var x = e.value.keys.first.toDouble();

      var y = e.value.values.first;

      return FlSpot(x, double.parse(y));
    }).toList();

    return LineChart(
      LineChartData(
        minY: (widget.min_y! - 5),
        maxY: (widget.max_y! + 5),
        minX: 0,
        maxX: 4,
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: SideTitles(
            showTitles: true,
            reservedSize: 35,
            getTextStyles: (value) => const TextStyle(
              color: Color(0xff68737d),
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
            getTitles: (val) {
              return DateFormat.Md().format(xValues[val.toInt()]!);
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
