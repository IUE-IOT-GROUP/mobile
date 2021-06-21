import 'dart:convert';
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prototype/screens/main_screen.dart';
import '../global.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';

  LoginScreen();
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  var enteredEmail;
  var enteredPassword;
  var errors = [];
  bool rememberMe = false;
  void initFieldsIfRemember() async {
    var prefs = await SharedPreferences.getInstance();
    var rememberedEmail = prefs.getString('email');
    var rememberedPassword = prefs.getString('password');
    rememberMe = prefs.getBool('rememberMe') ?? rememberMe;

    if (rememberedEmail != null && rememberedPassword != null) {
      emailController.text = rememberedEmail;
      passwordController.text = rememberedPassword;
    }
  }

  bool isFog = true;
  void fogOrCloud() async {
    var prefs = await SharedPreferences.getInstance();
    isFog = prefs.getBool('isFog') ?? isFog;
  }

  Future<bool> postRequest() async {
    var success = false;
    setState(() {
      Global.isLoading = true;
    });

    var url = '${Global.baseUrl}/login';
    var body = {'email': enteredEmail, 'password': enteredPassword, 'device_name': await getDeviceId()};

    await Global.h_post(url, body).then((http.Response response) {
      if (response.statusCode == 200) {
        success = true;
        Global.secureStorage.writeSecureData('token', jsonDecode(response.body)['token']);
        Global.secureStorage.writeSecureData('name', jsonDecode(response.body)['username']);
        Global.secureStorage.writeSecureData('email', jsonDecode(response.body)['email']);
        Global.secureStorage.writeSecureData('id', jsonDecode(response.body)['id'].toString());
        setState(() {
          Global.isLoading = true;
        });
      }
    });

    return success;
  }

  Future<String?> getDeviceId() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        return build.androidId;
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        return data.identifierForVendor;
      }
    } on PlatformException {}
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      Global.isLoading = false;
    });
    initFieldsIfRemember();
  }

  void initCredentials() {
    enteredEmail = emailController.text;
    enteredPassword = passwordController.text;
  }

  void login(BuildContext ctx) async {
    var prefs = await SharedPreferences.getInstance();

    initCredentials();
    if (isFog) {
      await prefs.setBool('isFog', isFog);
      Global.isFog = isFog;
    } else {
      await prefs.setBool('isFog', isFog);
      Global.isFog = isFog;
    }
    var isAuthenticated = await postRequest();
    if (enteredEmail == '' || enteredPassword == '') {
      setState(() {
        Global.isLoading = false;
        Global.warning(ctx, "Email or password can't be blank!");
      });
    } else if (!isAuthenticated) {
      setState(() {
        Global.isLoading = false;
      });

      Global.warning(ctx, 'Username or password is incorrect! Please check your credentials.');
    } else {
      Global.email = enteredEmail;
      Global.password = enteredPassword;

      if (rememberMe) {
        await prefs.setString('email', enteredEmail);
        await prefs.setString('password', enteredPassword);
        await prefs.setBool('rememberMe', rememberMe);
      } else {
        if (prefs.getString('email') != null || prefs.getString('password') != null) {
          await prefs.remove('email');
          await prefs.remove('password');
        }
        await prefs.setBool('rememberMe', false);
      }
      await Navigator.of(ctx).pushReplacementNamed(MainScreen.routeName);
    }
  }

  var fog = 'Fog';
  var cloud = 'Cloud';
  @override
  Widget build(BuildContext context) {
    return Scaffold(resizeToAvoidBottomInset: false, backgroundColor: Theme.of(context).primaryColor, body: bodyCard());
  }

  Widget bodyCard() {
    return Card(
      color: Theme.of(context).primaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 40),
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.2,
            child: Card(
              elevation: 40,
              color: Theme.of(context).primaryColor,
              child: Image.asset('assets/images/iotms.png'),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(50),
            child: Text(
              'IoT Management System',
              style: TextStyle(
                color: Theme.of(context).accentColor,
                fontFamily: 'Raleway',
                fontWeight: FontWeight.bold,
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
              keyboardType: TextInputType.emailAddress,
              autofocus: false,
              textAlign: TextAlign.center,
              style: TextStyle(color: Theme.of(context).accentColor),
              controller: emailController,
              decoration: InputDecoration(
                hintText: 'E-mail',
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
              style: TextStyle(color: Theme.of(context).accentColor),
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Password',
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(top: 8, left: 5, right: 5),
            child: Row(
              children: [
                Flexible(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.all(3),
                    child: Checkbox(
                      activeColor: Colors.grey,
                      value: rememberMe,
                      onChanged: (_) {
                        setState(() {
                          rememberMe = !rememberMe;
                        });
                      },
                    ),
                  ),
                ),
                Flexible(
                  flex: 3,
                  child: Text(
                    'Remember me',
                    style: TextStyle(color: Theme.of(context).accentColor),
                  ),
                ),
                Flexible(
                  flex: 3,
                  child: Container(),
                ),
                Flexible(
                  flex: 4,
                  child: TextButton(
                    onPressed: () => {},
                    child: Text(
                      'Forget Password?',
                      style: TextStyle(color: Theme.of(context).accentColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(),
                ),
              ),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
              minimumSize: MaterialStateProperty.all<Size>(Size(MediaQuery.of(context).size.width * 0.4, 30)),
            ),
            onPressed: () => login(context),
            child: Text(
              'Sign In',
              style: TextStyle(color: Colors.black),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Current status: ',
                style: TextStyle(color: Theme.of(context).accentColor, fontSize: 17),
              ),
              Text(
                '${isFog ? fog : cloud}',
                style: TextStyle(color: Theme.of(context).accentColor, fontSize: 17),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.cloud,
                color: Theme.of(context).accentColor,
              ),
              Switch(
                  value: isFog,
                  onChanged: (data) {
                    setState(() {
                      isFog = !isFog;
                    });
                  }),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Image.asset(
                  'assets/images/fog.png',
                  fit: BoxFit.cover,
                  color: Theme.of(context).accentColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
