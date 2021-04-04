import 'package:flutter/material.dart';
import "../models/device.dart";
import "../models/place.dart";
import "../models/device_type.dart";
import "../dummy_data.dart";

class CreateDeviceTextField extends StatefulWidget {
  final String? textString;
  final TextEditingController? textController;
  final bool? isDropDown;
  final bool? isDeviceType;

  CreateDeviceTextField(
      {this.textString,
      this.textController,
      this.isDropDown,
      this.isDeviceType});

  @override
  _CreateDeviceTextFieldState createState() => _CreateDeviceTextFieldState();
}

class _CreateDeviceTextFieldState extends State<CreateDeviceTextField> {
  @override
  Widget build(BuildContext context) {
    final device_types = DUMMY_DEVICE_TYPES;
    final places = DUMMY_PLACES;
    DeviceType? selectedDeviceType = device_types[0];
    Place? selectedPlace = places[0];
    final mq = MediaQuery.of(context);

    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(
            fit: FlexFit.tight,
            child: widget.textString!.length <= 10
                ? Text(widget.textString!,
                    style: TextStyle(
                      fontSize: 25,
                    ))
                : Text(
                    widget.textString!,
                    style: TextStyle(fontSize: 18),
                  ),
          ),
          Flexible(flex: 1, fit: FlexFit.tight, child: Container()),
          Container(
            width: mq.size.width * 0.4,
            child: Flexible(
              fit: FlexFit.tight,
              flex: 5,
              child: Container(
                padding: EdgeInsets.only(top: 5),
                child: !widget.isDropDown!
                    ? TextField(
                        style: TextStyle(
                          fontSize: 23,
                        ),
                        decoration: InputDecoration(),
                        controller: widget.textController,
                      )
                    : widget.isDeviceType!
                        ? Container(
                            margin: EdgeInsets.only(top: 15),
                            child: DropdownButton<DeviceType>(
                              value: selectedDeviceType,
                              onChanged: (DeviceType? newVal) {
                                setState(() {
                                  selectedDeviceType = newVal;
                                });
                              },
                              items: device_types.map((DeviceType dt) {
                                return DropdownMenuItem<DeviceType>(
                                  value: dt,
                                  child: Text(dt.title),
                                );
                              }).toList(),
                            ),
                          )
                        : Container(
                            margin: EdgeInsets.only(
                              top: 15,
                            ),
                            child: DropdownButton<Place>(
                              value: selectedPlace,
                              onChanged: (Place? newVal) {
                                setState(() {
                                  selectedPlace = newVal;
                                });
                              },
                              items: places.map((Place place) {
                                return DropdownMenuItem<Place>(
                                  value: place,
                                  child: Text(place.name),
                                );
                              }).toList(),
                            ),
                          ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
