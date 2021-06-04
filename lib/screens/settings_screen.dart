import 'package:flutter/material.dart';
import "../widgets/navDrawer.dart";
import "../global.dart";
import "../widgets/settings_edit_popup.dart";
import "../widgets/themeChange.dart";
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  static final routeName = "/settings-screen";

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Future<List<String>>? credentials;
  bool obscure = false;
  @override
  void initState() {
    super.initState();
    credentials = Global.getCredentials();
  }

  var newThemeColor;

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
          backgroundColor: Theme.of(context).primaryColor,
        ),
        backgroundColor: Theme.of(context).primaryColor,
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
                          color: Theme.of(context).accentColor,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Divider(
                color: Theme.of(context).accentColor,
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
                              color: Theme.of(context).accentColor,
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        FutureBuilder(
                          future: credentials,
                          initialData: null,
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              List<String> localCredentials = snapshot.data;
                              return Text(localCredentials[0],
                                  style: TextStyle(
                                      color: Theme.of(context).accentColor,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold));
                            }
                            return CircularProgressIndicator();
                          },
                        ),
                        Spacer(),
                        IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: Theme.of(context).accentColor,
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
                              color: Theme.of(context).accentColor,
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        FutureBuilder(
                          future: credentials,
                          initialData: null,
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              List<String> localCredentials = snapshot.data;
                              return Text(
                                obscure
                                    ? "${localCredentials[1]}"
                                    : '${localCredentials[1].replaceAll(RegExp(r"."), "*")}',
                                style: TextStyle(
                                    color: Theme.of(context).accentColor,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                              );
                            }
                            return CircularProgressIndicator();
                          },
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
                            color: Theme.of(context).accentColor,
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
                color: Theme.of(context).accentColor,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("User Information",
                      style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize: 24,
                          fontWeight: FontWeight.bold))
                ],
              ),
              Divider(color: Theme.of(context).accentColor),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "name: ",
                          style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        Text(
                          "erel",
                          style: TextStyle(
                              color: Theme.of(context).accentColor,
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
                          color: Theme.of(context).accentColor,
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "surname: ",
                          style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        Text(
                          "öztürk",
                          style: TextStyle(
                              color: Theme.of(context).accentColor,
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
                          color: Theme.of(context).accentColor,
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "mobile: ",
                          style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        Text(
                          "+905396169835",
                          style: TextStyle(
                              color: Theme.of(context).accentColor,
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
                          color: Theme.of(context).accentColor,
                        )
                      ],
                    ),
                  ],
                ),
              ),
              // Divider(
              //   color: Theme.of(context).accentColor,
              // ),
              // Text(
              //   "App Settings",
              //   style: TextStyle(
              //       color: Theme.of(context).accentColor,
              //       fontSize: 24,
              //       fontWeight: FontWeight.bold),
              // ),
              // Divider(
              //   color: Theme.of(context).accentColor,
              // ),
              // Row(
              //   children: [
              //     Text(
              //       "Dark Theme",
              //       style: TextStyle(
              //         color: Theme.of(context).accentColor,
              //         fontSize: 24,
              //       ),
              //     ),
              //     Switch(
              //         value: Global.isDarkTheme,
              //         onChanged: (data) {
              //           setState(() {
              //             Global.isDarkTheme = !Global.isDarkTheme;
              //             ThemeChange.of(context).isDark = Global.isDarkTheme;
              //           });
              //         })
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
