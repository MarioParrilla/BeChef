import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../utils/AppData.dart';

class AuthService extends ChangeNotifier{

  final storage = const FlutterSecureStorage();

  Future<String?> login(String email, String password) async {

    Map<String, String> authData = {
      'email': email,
      'password': password,
    };

    final url = Uri.http(AppData.baseUrl, '/auth/login');

    final request = await http.post(url, headers: {"Content-Type": "application/json"}, body: json.encode(authData));

    final Map<String, dynamic> response = json.decode(request.body);

    if (response.containsKey('username')) {
      await storage.write(key: 'username', value: response['username']);
      return null;
    }else{
      return response['error'];
    }
  }

  Future<String?> createUser(String email, String password) async {

    Map<String, String> authData = {
      'email': email,
      'password': password,
    };

    final url = Uri.http(AppData.baseUrl, '/auth/register');

    final request = await http.post(url, headers: {"Content-Type": "application/json"}, body: json.encode(authData));

    final Map<String, dynamic> response = json.decode(request.body);

    if (response.containsKey('username')) {
      await storage.write(key: 'username', value: response['username']);
      return null;
    }else{
      return response['error'];
    }
  }


  Future logout() async {

    await storage.delete(key: 'username');

  }

  Future<String> readToken({int duration = 0}) async {

    await Future.delayed(Duration(seconds: duration));

    return await storage.read(key: 'username') ?? '';

  }


}