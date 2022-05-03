import 'package:flutter/material.dart';

class DataProfileProvider extends ChangeNotifier {

  String _username = '';
  String _description = '';
  String _urlImg = '';
  String _urlImgTemp = '';

  bool _usernameChanged = false;
  bool _descriptionChanged = false;
  bool _urlImgChanged = false;


  String get username => _username;
  String get description => _description;
  String get urlImg => _urlImg;
  String get urlImgTemp => _urlImgTemp;

  bool get usernameChanged => _usernameChanged;
  bool get descriptionChanged => _descriptionChanged;
  bool get urlImgChanged => _urlImgChanged;

  set username (String value){
    print('cambio nombre');
    _username = value;
    notifyListeners();
  }

  set description (String value){
        print('cambio desc');
    _description = value;
    notifyListeners();
  }

  set urlImg (String value){
    _urlImg = value;
    _urlImgTemp = value;
    notifyListeners();
  }

  set urlImgTemp (String value){
      print('cambio img');
    _urlImgTemp = value;
    notifyListeners();
  }


  set usernameChanged (bool value){
    _usernameChanged = value;
    notifyListeners();
  }

  set descriptionChanged (bool value){
    _descriptionChanged = value;
    notifyListeners();
  }

  set urlImgChanged (bool value){
    _urlImgChanged = value;
    notifyListeners();
  }  
}