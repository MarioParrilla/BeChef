import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../models/models.dart';
import '../utils/AppData.dart';

class DataUserLoggedService extends ChangeNotifier{

  final storage = const FlutterSecureStorage();

  Future getUserByToken(BuildContext context) async {
    final String? token = await storage.read(key: 'token');
    final url = Uri.http(AppData.baseUrl, '/api/users/getUser/${ token }');

    try {
      final request = await http.get(url).timeout(const Duration(seconds: 15));
      final Map<String, dynamic> response = json.decode(request.body);
      if (response.containsKey('username')) {
        return User.fromMap(response);
      }else{
        return null;
      }
    } catch (e) {
      await showDialog(context: context, builder: (_) => AppData.alert);
    }
  }

  Future changeBasicDataUser(BuildContext context, String newUsername, String newDescription) async {

    final String? token = await storage.read(key: 'token');
    
    Map<String, String> authData = {
      'token': token!,
      'username': newUsername,
      'description': newDescription,
    };    
    
    final url = Uri.http(AppData.baseUrl, '/api/users/');

    try {
      final request = await http.put(url, headers: {"Content-Type": "application/json"}, body: json.encode(authData)).timeout(const Duration(seconds: 15));

      final Map<String, dynamic> response = json.decode(request.body);
      
      if (response.containsKey('username')) {
        return User.fromMap(response);
      }else{
        return response;
      }
    } catch (e) {
      await showDialog(context: context, builder: (_) => AppData.alert);
    }


  }

}