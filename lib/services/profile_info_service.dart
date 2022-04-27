import 'dart:convert';

import 'package:be_chef_proyect/models/models.dart';
import 'package:be_chef_proyect/utils/AppData.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class ProfileInfoService extends ChangeNotifier{

  final List<User> _users = [];

  void test() async{
    final url = Uri.http(AppData.baseUrl, 'api/users');
    final resp = await http.get(url);

    print(resp.body);

    final List<dynamic> usersMap = json.decode(resp.body);
    print(usersMap);
  }


}