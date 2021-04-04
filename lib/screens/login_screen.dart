import 'package:flutter/material.dart';
import 'package:prototype/screens/main_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import "../SecureStorage.dart";

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final SecureStorage secureStorage = SecureStorage();

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  var enteredUsername;
  var enteredPassword;

  void initCredentials() {
    enteredUsername = usernameController.text;
    enteredPassword = passwordController.text;
  }

  warning(BuildContext ctx) {
    initCredentials();
    AlertDialog alert = AlertDialog(
      title: Text('WARNING'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text("Username or password can't be blank!"),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  void login(BuildContext ctx) async {
    initCredentials();
    //if check'ler
    //user'i bul ve ID'sini gönder
    if (enteredUsername == "" || enteredPassword == "") {
      setState(() {
        warning(ctx);
      });
    } else {
      print(enteredUsername);
      secureStorage.writeSecureData("username", enteredUsername);
      Navigator.of(ctx).pushNamed(MainScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(31, 30, 44, 1),
      body: Card(
        color: Color.fromRGBO(31, 30, 44, 1),
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
              margin: EdgeInsets.only(left: 10, right: 10),
              child: TextField(
                style: TextStyle(color: Colors.grey),
                controller: usernameController,
                decoration: InputDecoration(
                  fillColor: Colors.grey,
                  focusColor: Color.fromRGBO(34, 33, 47, 0.7),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  hintText: "Username",
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: TextField(
                style: TextStyle(color: Colors.grey),
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromRGBO(34, 33, 47, 1)),
                    borderRadius: BorderRadius.circular(15),
                  ),
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
      ),
    );
  }
}
