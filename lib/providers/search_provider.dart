import 'package:flutter/material.dart';

import '../models/models.dart';
import '../utils/AppData.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchProvider extends ChangeNotifier {
  List<Recipe> _recipes = [];
  List<User> _users = [];

  bool isLoading = false;

  List<Recipe> get recipes => _recipes;
  List<User> get users => _users;

  set recipes(List<Recipe> value) {
    _recipes = value;
    notifyListeners();
  }

  set users(List<User> value) {
    _users = value;
    notifyListeners();
  }

  getRecipesByQuery(String query, BuildContext context) async {
    List<Recipe> recipes = [];

    //final url = Uri.https(AppData.baseUrl, '/api/recipes/q/$query');
    final url = Uri.http(AppData.baseUrl, '/api/recipes/q/$query');

    try {
      final request = await http.get(url).timeout(const Duration(seconds: 15));
      final response = json.decode(request.body);

      response.forEach((value) {
        final temp = Recipe.fromMap(value);
        temp.description =
            const Utf8Decoder().convert(temp.description!.runes.toList());
        temp.name = const Utf8Decoder().convert(temp.name!.runes.toList());
        temp.steps = const Utf8Decoder().convert(temp.steps!.runes.toList());
        recipes.add(temp);
      });
      _recipes = recipes;
    } catch (e) {
      print(e);
      await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => AppData.alert(context));
    }
    notifyListeners();
  }

  getUsersByQuery(String query, BuildContext context) async {
    List<User> users = [];

    //final url = Uri.https(AppData.baseUrl, '/api/users/q/$query');
    final url = Uri.http(AppData.baseUrl, '/api/users/q/$query');

    try {
      final request = await http.get(url).timeout(const Duration(seconds: 15));
      final response = json.decode(request.body);

      response.forEach((value) {
        final temp = User.fromMap(value);
        temp.username =
            const Utf8Decoder().convert(temp.username!.runes.toList());
        temp.email = const Utf8Decoder().convert(temp.email!.runes.toList());
        temp.description =
            const Utf8Decoder().convert(temp.description!.runes.toList());
        temp.password =
            const Utf8Decoder().convert(temp.password!.runes.toList());
        users.add(temp);
      });
      _users = users;
    } catch (e) {
      print(e);
      await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => AppData.alert(context));
    }
    notifyListeners();
  }
}
