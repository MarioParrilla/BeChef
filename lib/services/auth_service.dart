import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService extends ChangeNotifier{
  final String _baseUrl = 'identitytoolkit.googleapis.com';
  final String _firebaseToken = 'AIzaSyDM4idPlG42WFi0dl2BZ0lqvMLidT5azpI';

  final storage = const FlutterSecureStorage();

  Future<String?> login(String email, String password) async {

    Map<String, dynamic> authData = {
      'email': email,
      'password': password,
    };

    final url = Uri.https(_baseUrl, '/v1/accounts:signInWithPassword', {
      'key': _firebaseToken,
    });

    final request = await http.post(url, body: json.encode(authData));

    final Map<String, dynamic> response = json.decode(request.body);

    if (response.containsKey('idToken')) {
      await storage.write(key: 'idToken', value: response['idToken']);
      return null;
    }else{
      return response['error']['message'];
    }
  }

  Future<String?> createUser(String email, String password) async {

    Map<String, dynamic> authData = {
      'email': email,
      'password': password,
    };

    final url = Uri.https(_baseUrl, '/v1/accounts:signUp', {
      'key': _firebaseToken,
    });

    final request = await http.post(url, body: json.encode(authData));

    final Map<String, dynamic> response = json.decode(request.body);

    if (response.containsKey('idToken')) {
      await storage.write(key: 'idToken', value: response['idToken']);
      return null;
    }else{
      return response['error']['message'];
    }
  }


  Future logout() async {

    await storage.delete(key: 'idToken');

  }

  Future<String> readToken({int duration = 0}) async {

    await Future.delayed(Duration(seconds: duration));

    return await storage.read(key: 'idToken') ?? '';

  }


}