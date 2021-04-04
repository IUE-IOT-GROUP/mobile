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
      body: Card(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(50),
                child: Text(
                  "Welcome to IMS!",
                  style: TextStyle(
                    backgroundColor: Theme.of(context).primaryColor,
                    color: Theme.of(context).accentColor,
                    //fontFamily: "RobotoCondensed",
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: "Username"),
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: "Password"),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(5),
                      child: Text("Remember me"),
                    ),
                    Checkbox(
                      value: false,
                      onChanged: (_) {
                        //remember me
                      },
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                    ),
                    RaisedButton(
                      child: Text("Login"),
                      color: Colors.green,
                      onPressed: () => login(context),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
