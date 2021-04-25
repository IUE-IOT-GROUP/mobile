import 'package:flutter/material.dart';

class TemperatureItem extends StatefulWidget {
  int temperature;

  TemperatureItem(this.temperature);

  @override
  _TemperatureItemState createState() => _TemperatureItemState();
}

class _TemperatureItemState extends State<TemperatureItem> {
  //mq.width = 0.65
  int? index = 1;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.only(left: 5),
          child: Text(
            "Temperature: ",
            style: TextStyle(fontSize: 20),
          ),
        ),
        SizedBox(
          width: 15,
        ),
        Text(
          index == 1
              ? "${widget.temperature}"
              : "${widget.temperature * 1.8 + 32}",
          style: TextStyle(color: Colors.green, fontSize: 20),
        ),
        SizedBox(
          width: 20,
        ),
        DropdownButton(
          value: index,
          items: [
            DropdownMenuItem(
              child: Text("°C"),
              value: 1,
            ),
            DropdownMenuItem(
              child: Text("°F"),
              value: 2,
            ),
          ],
          onChanged: (int? val) {
            print(val);
            setState(() {
              index = val;
            });
          },
        ),
      ],
    );
  }
}
