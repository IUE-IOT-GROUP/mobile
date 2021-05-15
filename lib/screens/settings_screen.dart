import 'package:flutter/material.dart';
import "../widgets/navDrawer.dart";
import "../global.dart";
import "../widgets/custom_dropdown.dart";
import "../widgets/settings_edit_popup.dart";

class SettingsScreen extends StatefulWidget {
  static final routeName = "/settings-screen";

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    var emailController = TextEditingController(text: Global.email);
    var passwordController = TextEditingController(text: Global.password);
    var nameController = TextEditingController(text: "erel");
    var surnameController = TextEditingController(text: "öztürk");
    var mobileController = TextEditingController(text: "+905396169835");
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        drawer: NavDrawer(),
        appBar: AppBar(
          backgroundColor: Global.pColor(context),
        ),
        backgroundColor: Global.pColor(context),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Text(
                      "User Credentials",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Divider(
                color: Colors.white,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "email: ",
                          style: TextStyle(
                              color: Global.aColor(context),
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        Text(
                          Global.email,
                          style: TextStyle(
                              color: Global.aColor(context),
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: Global.aColor(context),
                          ),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return EditPopup(
                                      "email", Global.email, emailController);
                                });
                          },
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "password: ",
                          style: TextStyle(
                              color: Global.aColor(context),
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        Text(
                          obscure
                              ? "${Global.password}"
                              : '${Global.password.replaceAll(RegExp(r"."), "*")}',
                          style: TextStyle(
                              color: Global.aColor(context),
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        SizedBox(
                          width: 30,
                        ),
                        Checkbox(
                            value: obscure,
                            onChanged: (_) {
                              setState(() {
                                obscure = !obscure;
                              });
                            }),
                        IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: Global.aColor(context),
                          ),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return EditPopup(
                                    "password",
                                    Global.email,
                                    passwordController,
                                  );
                                });
                          },
                        )
                      ],
                    )
                  ],
                ),
              ),
              Divider(
                color: Colors.white,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("User Information",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold))
                ],
              ),
              Divider(color: Colors.white),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "name: ",
                          style: TextStyle(
                              color: Global.aColor(context),
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        Text(
                          "erel",
                          style: TextStyle(
                              color: Global.aColor(context),
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return EditPopup(
                                      "name", Global.email, nameController);
                                });
                          },
                          color: Global.aColor(context),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "surname: ",
                          style: TextStyle(
                              color: Global.aColor(context),
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        Text(
                          "öztürk",
                          style: TextStyle(
                              color: Global.aColor(context),
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return EditPopup(
                                      "email", Global.email, surnameController);
                                });
                          },
                          color: Global.aColor(context),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "mobile: ",
                          style: TextStyle(
                              color: Global.aColor(context),
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        Text(
                          "+905396169835",
                          style: TextStyle(
                              color: Global.aColor(context),
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return EditPopup(
                                      "email", Global.email, mobileController);
                                });
                          },
                          color: Global.aColor(context),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Divider(
                color: Colors.white,
              ),
              Text(
                "App Settings",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              Divider(
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
