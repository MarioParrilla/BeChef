import 'package:be_chef_proyect/providers/providers.dart';
import 'package:be_chef_proyect/screens/screens.dart';
import 'package:be_chef_proyect/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {

  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final authProvider = Provider.of<AuthService>(context, listen: false);

    return ChangeNotifierProvider(
      create: (_) => BotttonNavProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: const Image(image: AssetImage('assets/bechef_logo.png'), width:50, height:50, color: Colors.white),
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
        bottomNavigationBar: const _BNavBar(),
        body: const _Pages(),
      ),
    );
  }
}

class _Pages extends StatelessWidget {
  const _Pages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final bottonNavProvider = Provider.of<BotttonNavProvider>(context);

    return PageView(
      controller: bottonNavProvider.pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: [

        const HomePageScreen(),

        Container(
          color: Colors.greenAccent,
        ), 
        const ProfileScreen(), 

      ],
    );
  }
}

class _BNavBar extends StatelessWidget {
  const _BNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final bottonNavProvider = Provider.of<BotttonNavProvider>(context);

    return BottomNavigationBar(
          currentIndex: bottonNavProvider.currentIndex,
          onTap: (index) => bottonNavProvider.currentIndex = index,
          selectedItemColor: Colors.deepOrange,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio', ),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Busqueda', ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil', ),
          ],
        );
  }
}