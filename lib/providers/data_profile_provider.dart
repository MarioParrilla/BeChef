import 'package:flutter/material.dart';

class DataProfileProvider extends ChangeNotifier {

  String _username = '';

  String get username => _username;

  set username  (String value){
    _username = value;
    notifyListeners();
  }

}