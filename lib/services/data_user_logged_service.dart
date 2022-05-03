import 'dart:convert';
import 'dart:io';
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
      await showDialog(context: context, builder: (_) => AppData.alert(context));
    }
  }

  Future changeBasicDataUser(BuildContext context, String newUsername, String newDescription, File? img) async {

    final String? token = await storage.read(key: 'token');   
    dynamic response;
    try {

        Map<String, String> authData = {
          'token': token!,
          'username': newUsername,
          'description': newDescription,
        }; 
      if(img == null){
        response = await _changeWithoutImg(authData);
      }else{
        response = await _changeWithImg(authData, img);
      }

      if (response.containsKey('username')) {
        return User.fromMap(response);
      }else{
        return response;
      }
    } catch (e) {
      print(e);
      await showDialog(context: context, builder: (_) => AppData.alert(context));
    }
  }

  Future<Map<String, dynamic>> _changeWithoutImg(Map<String, String> authData) async {

    final String? token = await storage.read(key: 'token');
    final url = Uri.http(AppData.baseUrl, '/api/users/');

    final request = http.MultipartRequest('PUT', url);
    request.fields.addAll(authData);
    final streamResponse = await request.send();
    final resp = await http.Response.fromStream(streamResponse).timeout(const Duration(seconds: 15));

    return json.decode(resp.body);
  }

  Future<Map<String, dynamic>> _changeWithImg(Map<String, String> authData, File img) async {

    final String? token = await storage.read(key: 'token');
      
    final url = Uri.http(AppData.baseUrl, '/api/users/');

      final request = http.MultipartRequest('PUT', url);
      request.files.add(await http.MultipartFile.fromPath('img', img.path));
      request.fields.addAll(authData);
      final streamResponse = await request.send();
      final resp = await http.Response.fromStream(streamResponse).timeout(const Duration(seconds: 15));
      
      return json.decode(resp.body);
  }

}