import 'package:flutter/material.dart';

class User {
  final String? id;
  final String? email;
  final String? userName;
  final String? password;

  const User(
      {@required this.id, this.email, @required this.userName, this.password});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"],
      email: json["email"],
      userName: json["username"],
    );
  }
}
