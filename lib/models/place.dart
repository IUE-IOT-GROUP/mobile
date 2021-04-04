import 'package:flutter/material.dart';
import "./room.dart";

class Place {
  final String id;
  final String name;
  final String imageUrl;
  final List<Room> roomList;

  const Place(
      @required this.id, @required this.name, this.imageUrl, this.roomList);
}
