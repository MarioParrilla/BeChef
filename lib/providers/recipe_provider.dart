import 'package:flutter/material.dart';

class RecipeProvider extends ChangeNotifier {
  String _id = '';
  String _name = '';
  String _description = '';
  String _steps = '';
  String _category = '';
  String _urlImg = '';
  String _urlImgTemp = '';

  bool _nameChanged = false;
  bool _descriptionChanged = false;
  bool _stepsChanged = false;
  bool _categoryChanged = false;
  bool _urlImgChanged = false;

  String get id => _id;
  String get name => _name;
  String get description => _description;
  String get steps => _steps;
  String get category => _category;
  String get urlImg => _urlImg;
  String get urlImgTemp => _urlImgTemp;

  bool get nameChanged => _nameChanged;
  bool get descriptionChanged => _descriptionChanged;
  bool get stepsChanged => _stepsChanged;
  bool get categoryChanged => _categoryChanged;
  bool get urlImgChanged => _urlImgChanged;

  set id(String value) {
    _id = value;
    notifyListeners();
  }

  set name(String value) {
    _name = value;
    notifyListeners();
  }

  set description(String value) {
    _description = value;
    notifyListeners();
  }

  set steps(String value) {
    _steps = value;
    notifyListeners();
  }

  set category(String value) {
    _category = value;
    notifyListeners();
  }

  set urlImg(String value) {
    _urlImg = value;
    _urlImgTemp = value;
    notifyListeners();
  }

  set urlImgTemp(String value) {
    _urlImgTemp = value;
    notifyListeners();
  }

  set nameChanged(bool value) {
    _nameChanged = value;
    notifyListeners();
  }

  set descriptionChanged(bool value) {
    _descriptionChanged = value;
    notifyListeners();
  }

  set stepsChanged(bool value) {
    _stepsChanged = value;
    notifyListeners();
  }

  set categoryChanged(bool value) {
    _categoryChanged = value;
    notifyListeners();
  }

  set urlImgChanged(bool value) {
    _urlImgChanged = value;
    notifyListeners();
  }
}
