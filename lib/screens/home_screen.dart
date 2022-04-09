import 'package:be_chef_proyect/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {

  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final authProvider = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Image(image: AssetImage('assets/bechef_logo.png'), width:50, height:50, color: Colors.white)),
        backgroundColor: Colors.deepOrange,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: (){
              authProvider.logout();
              NotificationsService.showSnackBar('Has cerrado sesión en tu cuenta');
              Navigator.pushReplacementNamed(context, 'login');
            },
          ),
        ] ,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: const [],
        ),
      ),
    );
  }
}