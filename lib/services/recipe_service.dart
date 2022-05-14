import 'dart:convert';
import 'dart:io';

import 'package:be_chef_proyect/models/models.dart';
import 'package:be_chef_proyect/providers/providers.dart';
import 'package:be_chef_proyect/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../providers/list_category_provider.dart';
import '../utils/AppData.dart';

class RecipeService extends ChangeNotifier {
  final storage = const FlutterSecureStorage();

  Future<List<Recipe>> findRecipesByCategory(
      BuildContext context, String category) async {
    ListCategoryProvider listCategoryProvider =
        Provider.of<ListCategoryProvider>(context);
    List<Recipe> recipes = [];

    final url = Uri.http(AppData.baseUrl, '/api/recipes/category/' + category);

    try {
      final request = await http.get(url).timeout(const Duration(seconds: 15));
      final response = json.decode(request.body);

      response.forEach((value) {
        final temp = Recipe.fromMap(value);
        recipes.add(temp);
      });

      listCategoryProvider.recipes.addAll(recipes);
    } catch (e) {
      print(e);
      await showDialog(
          context: context, builder: (_) => AppData.alert(context));
    }
    //await Future.delayed(const Duration(seconds: 3));
    return recipes;
  }

  Future<List<Recipe>> findRecipesByCategoryPaged(
      BuildContext context, String category, int lastID) async {
    List<Recipe> recipes = [];

    final url = Uri.http(AppData.baseUrl,
        '/api/recipes/category/' + category + '/' + lastID.toString());

    try {
      final request = await http.get(url).timeout(const Duration(seconds: 15));
      final response = json.decode(request.body);

      response.forEach((value) {
        final temp = Recipe.fromMap(value);
        recipes.add(temp);
      });
    } catch (e) {
      print(e);
      await showDialog(
          context: context, builder: (_) => AppData.alert(context));
    }
    //await Future.delayed(const Duration(seconds: 3));
    return recipes;
  }

  Future<String> findUsernameById(BuildContext context, String userId) async {
    String recipes = "";

    final url = Uri.http(AppData.baseUrl, '/api/users/' + userId);

    try {
      final request = await http.get(url).timeout(const Duration(seconds: 15));
      final response = json.decode(request.body);

      recipes = response["username"];
    } catch (e) {
      print(e);
      await showDialog(
          context: context, builder: (_) => AppData.alert(context));
    }
    //await Future.delayed(const Duration(seconds: 3));
    return recipes;
  }

  Future<List<Recipe>> loadRecipesUserLogged(BuildContext context) async {
    final String? token = await storage.read(key: 'token');
    final loggedUserRecipesProvider =
        Provider.of<LoggedUserRecipesProvider>(context, listen: false);

    List<Recipe> recipes = [];

    final url = Uri.http(AppData.baseUrl, '/api/recipes/${token}');

    try {
      final request = await http.get(url).timeout(const Duration(seconds: 15));
      final response = json.decode(request.body);

      response.forEach((value) {
        final temp = Recipe.fromMap(value);
        recipes.add(temp);
      });
      loggedUserRecipesProvider.recipes = recipes;
    } catch (e) {
      print(e);
      await showDialog(
          context: context, builder: (_) => AppData.alert(context));
    }
    //await Future.delayed(const Duration(seconds: 3));
    return recipes;
  }

  Future changeDataRecipe(BuildContext context, String? id, String name,
      String description, String steps, String category, File? img) async {
    final String? token = await storage.read(key: 'token');
    dynamic response;
    try {
      Map<String, String> authData = {
        'token': token!,
        if (id != null) 'id': id,
        'name': name,
        'description': description,
        'steps': steps,
        'category': category,
      };
      if (img == null) {
        response = await _changeWithoutImg(authData);
      } else {
        response = await _changeWithImg(authData, img);
      }
      if (response.containsKey('name')) {
        return Recipe.fromMap(response);
      } else {
        return response;
      }
    } catch (e) {
      print(e);
      await showDialog(
          context: context, builder: (_) => AppData.alert(context));
    }
  }

  Future<Map<String, dynamic>> _changeWithoutImg(
      Map<String, String> authData) async {
    final String? token = await storage.read(key: 'token');
    final url = Uri.http(AppData.baseUrl, '/api/recipes/');

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

    final url = Uri.http(AppData.baseUrl, '/api/recipes/');

    final request = http.MultipartRequest('PUT', url);
    request.files.add(await http.MultipartFile.fromPath('img', img.path));
    request.fields.addAll(authData);
    final streamResponse = await request.send();
    final resp = await http.Response.fromStream(streamResponse)
        .timeout(const Duration(seconds: 15));

    return json.decode(resp.body);
  }

  Future removeRecipe(BuildContext context, int id) async {
    final url = Uri.http(AppData.baseUrl, '/api/recipes/${id}');
    try {
      final request =
          await http.delete(url).timeout(const Duration(seconds: 15));
      final response = json.decode(request.body);
      print(response.runtimeType);
      if (response != true) {
        NotificationsService.showSnackBar('Registro de la cuenta incorrecto');
        return false;
      } else {
        return true;
      }
    } catch (e) {
      print(e);
      await showDialog(
          context: context, builder: (_) => AppData.alert(context));
      return false;
    }
  }
}
