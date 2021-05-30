import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineTitles {
  String? _graphType;
  LineTitles();

  String? getGraphType() {
    return _graphType;
  }

  void setGraphType(String type) {
    _graphType = type;
  }

  getTitleData() => FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 35,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff68737d),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return 'MON';
              case 2:
                return 'WED';
              case 4:
                return 'FRI';
              case 6:
                return "SUN";
            }
            return '';
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            print("49$_graphType");
            if (_graphType == 'temperature') {
              switch (value.toInt()) {
                case 1:
                  return '22 °C';
                case 3:
                  return '26 °C';
                case 5:
                  return '30 °C';
                case 7:
                  return "34 °C";
                case 9:
                  return "38 °C";
              }
              return '';
            } else if (_graphType == "humidity") {
              switch (value.toInt()) {
                case 2:
                  return "30%";
                case 4:
                  return "50%";
                case 6:
                  return "70%";
              }
              return "";
            } else if (_graphType == "distance") {
              switch (value.toInt()) {
                case 2:
                  return "150";
                case 4:
                  return "250";
                case 6:
                  return "350";
              }
              return "";
            }
            return "";
          },
          reservedSize: 35,
          margin: 12,
        ),
      );
}
