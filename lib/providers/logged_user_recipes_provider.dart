import 'package:flutter/material.dart';

import '../models/models.dart';

class LoggedUserRecipesProvider extends ChangeNotifier {

  List<Recipe> _recipes = [];

  List<Recipe> get recipes => _recipes;

  set recipes (List<Recipe> value){
    print(value.length);
    _recipes = value;
    notifyListeners();
  }
}