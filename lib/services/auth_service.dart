import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';
import '../utils/AppData.dart';

class AuthService extends ChangeNotifier {
  final storage = const FlutterSecureStorage();

  Future<String?> login(
      BuildContext context, String email, String password) async {
    Map<String, String> authData = {
      'email': email,
      'password': password,
    };

    //final url = Uri.https(AppData.baseUrl, '/auth/login');
    final url = Uri.http(AppData.baseUrl, '/auth/login');

    try {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => AppData.loagindAlert(context));
      final request = await http
          .post(url,
              headers: {"Content-Type": "application/json"},
              body: json.encode(authData))
          .timeout(const Duration(seconds: 15));

      final Map<String, dynamic> response = json.decode(request.body);
      if (response.containsKey('token')) {
        await storage.write(key: 'token', value: response['token']);
        return null;
      } else {
        Navigator.of(context).pop();
        return response['error'];
      }
    } catch (e) {
      await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => AppData.alert(context));
    }
  }

  Future createUser(BuildContext context, String email, String password) async {
    Map<String, String> authData = {
      'email': email,
      'password': password,
    };

    //final url = Uri.https(AppData.baseUrl, '/auth/register');
    final url = Uri.http(AppData.baseUrl, '/auth/register');

    try {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => AppData.loagindAlert(context));
      final request = await http
          .post(url,
              headers: {"Content-Type": "application/json"},
              body: json.encode(authData))
          .timeout(const Duration(seconds: 15));

      final Map<String, dynamic> response = json.decode(request.body);

      if (response.containsKey('token')) {
        await storage.write(key: 'token', value: response['token']);

        User user = User.fromMap(response);
        user.username =
            const Utf8Decoder().convert(user.username!.runes.toList());
        user.email = const Utf8Decoder().convert(user.email!.runes.toList());
        user.description =
            const Utf8Decoder().convert(user.description!.runes.toList());
        user.password =
            const Utf8Decoder().convert(user.password!.runes.toList());

        return user;
      } else {
        Navigator.of(context).pop();
        return response['error'];
      }
    } catch (e) {
      await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => AppData.alert(context));
    }
  }

  Future logout() async {
    await storage.delete(key: 'token');
  }

  Future<String> readToken({int duration = 0}) async {
    await Future.delayed(Duration(seconds: duration));

    return await storage.read(key: 'token') ?? '';
  }
}
