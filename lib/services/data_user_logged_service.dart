import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../models/models.dart';
import '../utils/AppData.dart';

class DataUserLoggedService extends ChangeNotifier{

  final storage = const FlutterSecureStorage();

  Future getUserByToken() async {
    final String? token = await storage.read(key: 'token');
    final url = Uri.http(AppData.baseUrl, '/api/users/getUser/${ token }');

    final request = await http.get(url);

    final Map<String, dynamic> response = json.decode(request.body);

    if (response.containsKey('username')) {
      return User.fromMap(response);
    }else{
      return null;
    }
  }


}