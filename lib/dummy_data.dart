import 'package:flutter/material.dart';
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
  Place(
      "p1",
      "Home",
      "https://upload.wikimedia.org/wikipedia/commons/thumb/2/20/Spaghetti_Bolognese_mit_Parmesan_oder_Grana_Padano.jpg/800px-Spaghetti_Bolognese_mit_Parmesan_oder_Grana_Padano.jpg",
      []),
  Place(
      "p2",
      "Work",
      "https://upload.wikimedia.org/wikipedia/commons/3/30/Home_free_icon.svg",
      []),
  Place(
      "p3",
      "Summerplace",
      "https://upload.wikimedia.org/wikipedia/commons/3/30/Home_free_icon.svg",
      []),
  Place(
      "p4",
      "Factory",
      "https://upload.wikimedia.org/wikipedia/commons/3/30/Home_free_icon.svg",
      []),
];

const DUMMY_ROOMS = const [
  Room("r1", "Bedroom", []),
  Room("r2", "Living Room", []),
  Room("r3", "Kitchen", []),
  Room("r4", "Bathroom", []),
];

const DUMMY_USERS = const [
  User(
      id: "u1", email: "sample1@gmail.com", userName: "user1", password: "123"),
  User(
      id: "u2", email: "sample2@gmail.com", userName: "user2", password: "123"),
  User(
      id: "u3", email: "sample3@gmail.com", userName: "user3", password: "123"),
];

const DUMMY_DEVICE_TYPES = const [
  DeviceType("dt1", "sensor type-1"),
  DeviceType("dt2", "sensor type-2"),
  DeviceType("dt3", "sensor type-3"),
  DeviceType("dt4", "sensor type-4"),
];
