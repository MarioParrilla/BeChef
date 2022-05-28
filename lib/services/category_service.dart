import 'package:be_chef_proyect/models/models.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../utils/AppData.dart';

class CategoryService extends ChangeNotifier {
  Future<List<Category>> findCategories(BuildContext context) async {
    List<Category> categories = [];

    //final url = Uri.https(AppData.baseUrl, '/api/categories/');
    final url = Uri.http(AppData.baseUrl, '/api/categories/');

    try {
      final request = await http.get(url).timeout(const Duration(seconds: 15));
      final response = json.decode(request.body);

      response.forEach((value) {
        final temp = Category.fromMap(value);
        categories.add(temp);
      });
    } catch (e) {
      print(e);
      await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => AppData.alert(context));
    }
    //await Future.delayed(const Duration(seconds: 3));
    return categories;
  }
}
