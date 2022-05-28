import 'package:be_chef_proyect/models/models.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/AppData.dart';

class UserService extends ChangeNotifier {
  Future<User> findUserById(BuildContext context, int userID) async {
    User? user = User(
        id: null,
        username: null,
        email: null,
        password: null,
        admin: null,
        description: null,
        urlImg: null);

    //final url = Uri.https(AppData.baseUrl, '/api/users/${userID}');
    final url = Uri.http(AppData.baseUrl, '/api/users/${userID}');

    try {
      final request = await http.get(url).timeout(const Duration(seconds: 15));
      final response = json.decode(request.body);

      if (response.containsKey('token')) {
        return User.fromMap(response);
      } else {
        return response['error'];
      }
    } catch (e) {
      print(e);
      await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => AppData.alert(context));
    }
    //await Future.delayed(const Duration(seconds: 3));
    return user;
  }
}
