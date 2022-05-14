import 'package:flutter/material.dart';

import '../models/models.dart';

class LoggedUserRecipesProvider extends ChangeNotifier {
  List<Recipe> _recipes = [];

  List<Recipe> get recipes => _recipes;

  set recipes(List<Recipe> value) {
    _recipes = value;
    notifyListeners();
  }

  addRecipe(Recipe recipe) {
    _recipes.add(recipe);
    notifyListeners();
  }

  removeRecipe(int id) {
    _recipes.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  replaceRecipe(Recipe recipe) {
    _recipes.removeWhere((element) => element.id == recipe.id);
    _recipes.add(recipe);
    notifyListeners();
  }
}
