import 'dart:convert';

import 'package:be_chef_proyect/models/models.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class RecipeService extends ChangeNotifier{
  final String _baseUrl = 'bechefapp-6b2c7-default-rtdb.europe-west1.firebasedatabase.app';
  final List<Recipe> _recipes = [];

  Future<List<Recipe>?> loadRecipesByCategory(String category) async {
    final url = Uri.https(_baseUrl, 'recipes.json');
    final resp = await http.get(url);

    final Map<String, dynamic> recipesMap = json.decode(resp.body);

    recipesMap.forEach((key, value) {
      final temp = Recipe.fromMap( value );
      temp.id = key;
      _recipes.add(temp);
    });

  }


}