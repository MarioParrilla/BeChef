import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../models/models.dart';
import '../utils/AppData.dart';

class DataUserLoggedService extends ChangeNotifier {
  final storage = const FlutterSecureStorage();

  Future getUserByToken(BuildContext context) async {
    final String? token = await storage.read(key: 'token');
    //final url = Uri.https(AppData.baseUrl, '/api/users/getUser/');
    final url = Uri.http(AppData.baseUrl, '/api/users/getUser/');

    try {
      final request = http.MultipartRequest('POST', url);
      request.fields.addAll({
        'token': token!,
      });

      http.StreamedResponse streamResponse = await request.send();
      final resp = await http.Response.fromStream(streamResponse)
          .timeout(const Duration(seconds: 15));

      final response = json.decode(resp.body);

      if (response.containsKey('username')) {
        User user = User.fromMap(response);
        if (user.username != null) {
          user.username =
              const Utf8Decoder().convert(user.username!.runes.toList());
        }
        if (user.email != null) {
          user.email = const Utf8Decoder().convert(user.email!.runes.toList());
        }
        if (user.description != null) {
          user.description =
              const Utf8Decoder().convert(user.description!.runes.toList());
        }
        if (user.password != null) {
          user.password =
              const Utf8Decoder().convert(user.password!.runes.toList());
        }
        return user;
      } else {
        return null;
      }
    } catch (e) {
      print('Error getUserByToken ${e}');
      await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => AppData.alert(context));
    }
  }

  Future changeBasicDataUser(BuildContext context, String newUsername,
      String newDescription, File? img) async {
    final String? token = await storage.read(key: 'token');
    dynamic response;
    try {
      Map<String, String> authData = {
        'token': token!,
        'username': newUsername,
        'description': newDescription,
      };

      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => AppData.loagindAlert(context));
      if (img == null) {
        response = await _changeWithoutImg(authData);
      } else {
        response = await _changeWithImg(authData, img);
      }
      Navigator.of(context).pop();
      if (response.containsKey('username')) {
        User user = User.fromMap(response);
        if (user.username != null) {
          user.username =
              const Utf8Decoder().convert(user.username!.runes.toList());
        }
        if (user.email != null) {
          user.email = const Utf8Decoder().convert(user.email!.runes.toList());
        }
        if (user.description != null) {
          user.description =
              const Utf8Decoder().convert(user.description!.runes.toList());
        }
        if (user.password != null) {
          user.password =
              const Utf8Decoder().convert(user.password!.runes.toList());
        }

        return user;
      } else {
        return response;
      }
    } catch (e) {
      print('Error changeBasicDataUser ${e}');
      await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => AppData.alert(context));
    }
  }

  Future<Map<String, dynamic>> _changeWithoutImg(
      Map<String, String> authData) async {
    final String? token = await storage.read(key: 'token');
    //final url = Uri.https(AppData.baseUrl, '/api/users/');
    final url = Uri.http(AppData.baseUrl, '/api/users/');

    final request = http.MultipartRequest('PUT', url);
    request.fields.addAll(authData);
    final streamResponse = await request.send();
    final resp = await http.Response.fromStream(streamResponse)
        .timeout(const Duration(seconds: 15));

    return json.decode(resp.body);
  }

  Future<Map<String, dynamic>> _changeWithImg(
      Map<String, String> authData, File img) async {
    final String? token = await storage.read(key: 'token');

    //final url = Uri.https(AppData.baseUrl, '/api/users/');
    final url = Uri.http(AppData.baseUrl, '/api/users/');

    final request = http.MultipartRequest('PUT', url);
    request.files.add(await http.MultipartFile.fromPath('img', img.path));
    request.fields.addAll(authData);
    final streamResponse = await request.send();
    final resp = await http.Response.fromStream(streamResponse)
        .timeout(const Duration(seconds: 15));

    return json.decode(resp.body);
  }
}
