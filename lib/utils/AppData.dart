import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppData {
  static final String _baseUrl = '192.168.1.62:8000';

  static get baseUrl => _baseUrl;

    static AlertDialog alert (BuildContext context){
      return AlertDialog(
        title: Text("Error"),
        content: Container(
          height: 140,
          child: Column(
            children: [
              const Text("Actualmente el servidor no esta disponible, por favor intente mas tarde"),
              TextButton(onPressed:() => SystemChannels.platform.invokeMethod('SystemNavigator.pop'), child: const Text("Aceptar", style: TextStyle(color: Colors.deepOrange),)),
              TextButton(onPressed:() => Navigator.pushNamedAndRemoveUntil(context,'init',(_) => false), child: const Text("Reintentar", style: TextStyle(color: Colors.deepOrange),)),
            ],
          ),
        ),
      );
    }

}