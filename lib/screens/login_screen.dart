import 'dart:convert';
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prototype/dummy_data.dart';
import 'package:prototype/screens/main_screen.dart';
import "../SecureStorage.dart";
import '../global.dart';
import "../models/user.dart";
import 'package:http/http.dart' as http;
import '../global.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final List<User> userList = DUMMY_USERS;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var enteredEmail;
  var enteredPassword;
  var errors = [];

  Future<bool> postRequest() async {
    bool success = false;
    setState(() {
      Global.isLoading = true;
    });

    var url = "${Global.baseUrl}/login";
    var body = {
      "email": enteredEmail,
      "password": enteredPassword,
      "device_name": await getDeviceId()
    };

    await Global.post(url, body).then((http.Response response) {
      if (response.statusCode == 200) {
        success = true;
        Global.secureStorage.writeSecureData("token", response.body);
        setState(() {
          Global.isLoading = true;
        });

        Global.h_get("${Global.baseUrl}/me", appendToken: true)
            .then((http.Response response) {
          var user = User.fromJson(jsonDecode(response.body)['data']);

          Global.secureStorage.writeSecureData("name", user.name);
          Global.secureStorage.writeSecureData("email", user.email);
          Global.secureStorage.writeSecureData("id", user.id.toString());
        });
      }
    });

    return success;
  }

  getDeviceId() async {
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        return build.androidId;
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        return data.identifierForVendor;
      }
    } on PlatformException {
      print('Failed to get platform version');
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      Global.isLoading = false;
    });
    emailController.text = "erel@ozturk.com";
  }

  void initCredentials() {
    enteredEmail = emailController.text;
    enteredPassword = passwordController.text;
  }

  void login(BuildContext ctx) async {
    initCredentials();

    bool isAuthenticated = await postRequest();
    if (enteredEmail == "" || enteredPassword == "") {
      setState(() {
        Global.isLoading = false;
        Global.warning(ctx, "Email or password can't be blank!");
      });
    } else if (!isAuthenticated) {
      setState(() {
        Global.isLoading = false;
      });
      Global.warning(ctx,
          "Username or password is incorrect! Please check your credentials.");
    } else {
      Global.email = enteredEmail;
      Global.password = enteredPassword;
      Navigator.of(ctx).pushReplacementNamed(MainScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Global.pColor(context),
      body: Stack(
        children: <Widget>[bodyCard(), Global.showCircularProgress()],
      ),
    );
  }

  Widget bodyCard() {
    return Card(
      color: Global.pColor(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(50),
            child: Text(
              "IoT Management System",
              style: TextStyle(
                color: Colors.white,
                fontFamily: "Raleway",
                fontSize: 24,
                //fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.75,
            margin: EdgeInsets.only(left: 10, right: 10),
            decoration: BoxDecoration(
              color: Color.fromRGBO(255, 255, 255, .02),
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
            ),
            child: TextField(
              autofocus: false,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
              controller: emailController,
              decoration: InputDecoration(
                hintText: "E-mail",
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.75,
            margin: EdgeInsets.only(left: 10, right: 10),
            decoration: BoxDecoration(
              color: Color.fromRGBO(255, 255, 255, .02),
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
            ),
            child: TextField(
              textAlign: TextAlign.center,
              autofocus: false,
              style: TextStyle(color: Colors.white),
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: "Password",
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 8, left: 5, right: 5),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(3),
                  child: Checkbox(
                    value: false,
                    onChanged: (_) {
                      //remember me
                    },
                  ),
                ),
                Text(
                  "Remember me",
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.2,
                ),
                TextButton(
                  onPressed: () => {},
                  child: Text(
                    "Forget Password?",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            child: Text(
              "Sign In",
              style: TextStyle(color: Colors.black),
            ),
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(),
                ),
              ),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
              minimumSize: MaterialStateProperty.all<Size>(
                  Size(MediaQuery.of(context).size.width * 0.4, 30)),
            ),
            onPressed: () => login(context),
          )
        ],
      ),
    );
  }
}
