import 'dart:convert';

import 'package:be_chef_proyect/models/models.dart';
import 'package:be_chef_proyect/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../utils/AppData.dart';


class RecipeService extends ChangeNotifier{

  final storage = const FlutterSecureStorage();

  Future<List<Recipe>> loadRecipesUserLogged(BuildContext context) async {
    final String? token = await storage.read(key: 'token');
    final loggedUserRecipesProvider = Provider.of<LoggedUserRecipesProvider>(context, listen: false);

    List<Recipe> recipes = [];

    final url = Uri.http(AppData.baseUrl, '/api/recipes/${token}');

    try {
        
      final request = await http.get(url).timeout(const Duration(seconds: 15));
      final response = json.decode(request.body);

      response.forEach((value) {
        final temp = Recipe.fromMap( value );
        recipes.add(temp);
      });
      loggedUserRecipesProvider.recipes = recipes;
      
    } catch (e) {
      print(e);
      await showDialog(context: context, builder: (_) => AppData.alert(context));
    }
    //await Future.delayed(const Duration(seconds: 3));
    return recipes;
  }




}