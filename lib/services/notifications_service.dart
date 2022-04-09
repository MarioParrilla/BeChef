import 'package:flutter/material.dart';

class NotificationsService{

  static GlobalKey<ScaffoldMessengerState> messagerKey = GlobalKey<ScaffoldMessengerState>();

  static showSnackBar(String message){
    final snackBar = SnackBar(
      content: Text( message ),
    );

    messagerKey.currentState!.showSnackBar(snackBar);
  }

}