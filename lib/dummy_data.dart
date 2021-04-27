import 'package:flutter/material.dart';
import "./models/device.dart";
import "./models/place.dart";
import "./models/user.dart";
import "./models/device_type.dart";
import "./models/room.dart";

const DUMMY_DEVICES = const [
  // Device(
  //   id: "d1",
  //   name: "Temperature",
  //   protocol: "HTTP",
  //   type: DeviceType("dt4", "sensor type-4"),
  // ),
  // Device(
  //   id: "d2",
  //   name: "Humidity",
  //   protocol: "MQTT",
  //   type: DeviceType("dt3", "sensor type-3"),
  // ),
  // Device(
  //   id: "d3",
  //   name: "Distance",
  //   protocol: "HTTP",
  //   type: DeviceType("dt3", "sensor type-3"),
  // ),
  // Device(
  //   id: "d4",
  //   name: "Door-1",
  //   protocol: "AMQP",
  //   type: DeviceType("dt1", "sensor type-1"),
  // ),
  // Device(
  //   id: "d5",
  //   name: "Door-2",
  //   protocol: "AMQP",
  //   type: DeviceType("dt1", "sensor type-1"),
  // ),
  // Device(
  //   id: "d6",
  //   name: "Lights",
  //   protocol: "MQTT",
  //   type: DeviceType("dt2", "sensor type-2"),
  // ),
];

const DUMMY_PLACES = const [
  Place(1, "Home", [], []),
  Place(2, "Work", [], []),
  Place(3, "Summerplace", [], []),
  Place(4, "Factory", [
    Place(5, "test1", [], [
      Device(
        id: 1,
        name: "Temperature",
        protocol: "HTTP",
        type: DeviceType("dt4", "sensor type-4"),
      ),
      Device(
        id: 2,
        name: "Humidity",
        protocol: "MQTT",
        type: DeviceType("dt3", "sensor type-3"),
      ),
    ]),
    Place(6, "test2", [], []),
    Place(7, "test3", [], []),
    Place(8, "test4", [], []),
  ], []),
];

const DUMMY_ROOMS = const [
  Room("r1", "Bedroom", []),
  Room("r2", "Living Room", []),
  Room("r3", "Kitchen", []),
  Room("r4", "Bathroom", []),
];

var DUMMY_USERS = [
  User(id: 1, email: "sample1@gmail.com", name: "user1"),
  User(id: 2, email: "sample2@gmail.com", name: "user2"),
  User(id: 3, email: "sample3@gmail.com", name: "user3"),
  User(id: 4, email: "sample4@gmail.com", name: "erel"),
];

const DUMMY_DEVICE_TYPES = const [
  DeviceType("dt1", "sensor type-1"),
  DeviceType("dt2", "sensor type-2"),
  DeviceType("dt3", "sensor type-3"),
  DeviceType("dt4", "sensor type-4"),
];
