import 'package:flutter/material.dart';
import 'package:prototype/SecureStorage.dart';
import 'package:prototype/models/user.dart';
import 'package:prototype/screens/main_screen.dart';
import 'package:prototype/services/user.service.dart';
import '../widgets/navDrawer.dart';
import '../global.dart';
import '../widgets/themeChange.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  static final routeName = '/settings-screen';

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool obscure = false;
  Future<User>? currentUserFuture;

  User? currentUser;

  TextEditingController? nameController;
  TextEditingController? emailController;
  TextEditingController? passwordController;
  TextEditingController? newPasswordController;
  TextEditingController? newPasswordConfirmationController;
  TextEditingController? phoneNumberController;

  Future<User> fetchMe() async {
    var secureStorage = Global.secureStorage;
    var userId = await secureStorage.readSecureData(('id'));

    var user = await UserService.getUser(userId);

    return user;
  }

  void updateUserInfo() async {
    currentUser!.name = nameController!.text;
    currentUser!.email = emailController!.text;
    currentUser!.phoneNumber = phoneNumberController!.text;

    if (passwordController!.text.isNotEmpty) {
      if (newPasswordController!.text ==
          newPasswordConfirmationController!.text) {
        currentUser!.password = newPasswordController!.text;
      } else {
        Global.warning(context, 'Passwords do not match');
      }
    }
    var success = false;

    success = await UserService.updateUser(currentUser);

    if (success) {
      Navigator.of(context).popAndPushNamed(MainScreen.routeName);
    }
  }

  @override
  void initState() {
    super.initState();

    currentUserFuture = fetchMe();
  }

  var newThemeColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text('User Settings'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: currentUserFuture,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              currentUser = snapshot.data;

              nameController = TextEditingController(text: currentUser!.name);
              emailController = TextEditingController(text: currentUser!.email);
              passwordController = TextEditingController(text: '');
              newPasswordController = TextEditingController(text: '');
              newPasswordConfirmationController =
                  TextEditingController(text: '');
              phoneNumberController =
                  TextEditingController(text: currentUser!.phoneNumber);

              return Padding(
                padding: EdgeInsets.all(30),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Theme.of(context).accentColor),
                        controller: nameController,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).accentColor)),
                          labelText: 'Name',
                          labelStyle:
                              TextStyle(color: Theme.of(context).accentColor),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).accentColor, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).accentColor, width: 1),
                          ),
                          hintText: 'Enter your name',
                        ),
                      ),
                      Divider(),
                      TextField(
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Theme.of(context).accentColor),
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).accentColor)),
                          labelText: 'Email',
                          labelStyle:
                              TextStyle(color: Theme.of(context).accentColor),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).accentColor, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).accentColor, width: 1),
                          ),
                          hintText: 'Enter your email',
                        ),
                      ),
                      Divider(),
                      TextField(
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Theme.of(context).accentColor),
                        keyboardType: TextInputType.phone,
                        controller: phoneNumberController,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).accentColor)),
                          labelText: 'Phone Number',
                          labelStyle:
                              TextStyle(color: Theme.of(context).accentColor),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).accentColor, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).accentColor, width: 1),
                          ),
                          hintText: 'Enter your phone number',
                        ),
                      ),
                      Text(
                        'Change Your Password',
                        style: TextStyle(
                            fontSize: 25, color: Theme.of(context).accentColor),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        obscureText: true,
                        style: TextStyle(color: Theme.of(context).accentColor),
                        textAlign: TextAlign.center,
                        controller: passwordController,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).accentColor)),
                          labelText: 'Current Password',
                          labelStyle:
                              TextStyle(color: Theme.of(context).accentColor),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).accentColor, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).accentColor, width: 1),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Theme.of(context).accentColor),
                        obscureText: true,
                        controller: newPasswordController,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).accentColor)),
                          labelText: 'New Password',
                          labelStyle:
                              TextStyle(color: Theme.of(context).accentColor),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).accentColor, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).accentColor, width: 1),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Theme.of(context).accentColor),
                        obscureText: true,
                        controller: newPasswordConfirmationController,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).accentColor)),
                          labelText: 'Confirm New Password',
                          labelStyle:
                              TextStyle(color: Theme.of(context).accentColor),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).accentColor, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).accentColor, width: 1),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                            onPressed: updateUserInfo, child: Text('Save')),
                      )
                    ]),
              );
            }

            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
