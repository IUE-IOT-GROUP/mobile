import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:prototype/dummy_data.dart';
import 'SecureStorage.dart';
import 'widgets/progress_bar.dart';
import "./models/device.dart";
import "./models/place.dart";
import "./models/user.dart";
import 'package:shared_preferences/shared_preferences.dart';

class Global {
  static var prefs;
  static var email = "";
  static var password = "";
  static final String baseUrl = "https://api.iot-ms.xyz/api/v1";
  static final SecureStorage secureStorage = SecureStorage();
  static var initialState = 0;
  static bool isLoading = false;
  static bool isDarkTheme = true;

  static List<Device> devices = [];
  static List<Place> places = DUMMY_PLACES;

  static void setPrefs() async {
    prefs = await SharedPreferences.getInstance();
    while (true) {
      if (prefs.containsKey("isDark")) {
        isDarkTheme = prefs.getBool("isDark");
        break;
      }
    }
    print("aaa$isDarkTheme");
  }

  // static void setDarkTheme(yes) async {
  //   prefs = await SharedPreferences.getInstance();
  //   prefs.setBool("isDark", yes);
  // }

  static Future<Response> post(String url, Object body) async {
    Uri uri = Uri.parse(url);

    //show circular

    return await http
        .post(uri,
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json"
            },
            body: jsonEncode(body))
        .then((http.Response response) {
      // hide circular
      return response;
    });
  }

  static Future<Response> h_get(String url, {bool appendToken = false}) async {
    Uri uri = Uri.parse(url);
    String token;

    // fire loading event

    var headers = {
      "Content-Type": "application/json",
      "Accept": "application/json"
    };

    if (appendToken) {
      token = await secureStorage.readSecureData("token");
      headers.putIfAbsent("Authorization", () => "Bearer " + token);
    }

    var response =
        await http.get(uri, headers: headers).then((http.Response response) {
      return response;
    });

    // fire loading finished event

    return response;
  }

  static alert(BuildContext ctx, String title, String message) {
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(message),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.of(ctx).pop();
          },
        ),
      ],
    );
    showDialog(
        context: ctx,
        builder: (BuildContext context) {
          return alert;
        });
  }

  static warning(BuildContext ctx, String message) {
    alert(ctx, "WARNING", message);
  }

  static success(BuildContext ctx, String message) {
    alert(ctx, "SUCCESS", message);
  }

  static Widget showCircularProgress() {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }
}
