import 'dart:convert';

import '../global.dart';
import '../models/user.dart';
import 'package:http/http.dart' as http;

class UserService {
  static String usersUrl = '${Global.baseUrl}/users';

  static Future<User> getUser(String? id) async {
    var url = '$usersUrl/$id';

    var user = User();

    await Global.h_get(url, appendToken: true).then((http.Response response) async {
      var jsonResponse = jsonDecode(response.body);

      user = User.fromJson(jsonResponse['data']);
    });

    return user;
  }

  static Future<bool> updateUser(User? user) async {
    var url = '$usersUrl/${user!.id}';

    var body = {'name': user.name, 'email': user.email, 'phone_number': user.phoneNumber};

    if (user.password != null && user.password!.isEmpty) {
      body['password'] = user.password;
    }

    var response = await Global.h_update(url, body, appendToken: true);

    if (200 >= response.statusCode && response.statusCode <= 300) {
      return true;
    }

    return false;
  }
}
