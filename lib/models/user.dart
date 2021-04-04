import 'package:flutter/material.dart';

class User {
  final String? id;
  final String? email;
  final String? userName;
  final String? password;

  const User(
      {@required this.id,
      this.email,
      @required this.userName,
      @required this.password});
}
