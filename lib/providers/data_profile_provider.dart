import 'package:flutter/material.dart';

class DataProfileProvider extends ChangeNotifier {

  String _username = '';
  String _description = '';

  String get username => _username;
  String get description => _description;

  set username (String value){
    _username = value;
    notifyListeners();
  }

    set description (String value){
    _description = value;
    notifyListeners();
  }

}