import 'package:flutter/material.dart';

class DataProfileProvider extends ChangeNotifier {

  String _username = '';
  String _description = '';
  String _urlImg = '';

  String get username => _username;
  String get description => _description;
  String get urlImg => _urlImg;

  set username (String value){
    _username = value;
    notifyListeners();
  }

  set description (String value){
    _description = value;
    notifyListeners();
  }

  set urlImg (String value){
    _urlImg = value;
    notifyListeners();
  }

}