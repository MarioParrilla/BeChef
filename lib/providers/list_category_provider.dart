import 'package:flutter/material.dart';

import '../models/models.dart';

class ListCategoryProvider extends ChangeNotifier {
  List<Recipe> _recipes = [];

  bool isLoading = false;

  List<Recipe> get recipes => _recipes;

  set recipes(List<Recipe> value) {
    _recipes = value;
    notifyListeners();
  }

  addRecipe(Recipe recipe) {
    _recipes.add(recipe);
    notifyListeners();
  }
}
