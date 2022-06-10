import 'package:be_chef_proyect/providers/data_profile_provider.dart';
import 'package:be_chef_proyect/services/services.dart';
import 'package:flutter/material.dart';
import 'package:be_chef_proyect/screens/screens.dart';
import 'package:provider/provider.dart';

import '../providers/login_form_provider.dart';

class InitScreen extends StatelessWidget {
  const InitScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final dataUserLoggedService =
        Provider.of<DataUserLoggedService>(context, listen: false);
    final dataProfileProvider =
        Provider.of<DataProfileProvider>(context, listen: false);

    Future changeScreen() async {
      dynamic token = await authService.readToken(duration: 3);
      if (token != '') {
        dynamic user = await dataUserLoggedService.getUserByToken(context);

        if (user != null) {
          dataProfileProvider.username = user.username;
          dataProfileProvider.description = user.description;
          dataProfileProvider.urlImg = user.urlImg != null ? user.urlImg : '';

          Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => const HomeScreen(),
                transitionsBuilder: (_, animation, __, child) =>
                    FadeTransition(opacity: animation, child: child),
                transitionDuration: const Duration(milliseconds: 1000),
              ));
        } else {
          authService.logout();
          final loginForm = Provider.of<LoginFormProvider>(context);
          loginForm.email = '';
          loginForm.password = '';
          loginForm.isLoading = false;
          Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => const LoginScreen(),
                transitionsBuilder: (_, animation, __, child) =>
                    FadeTransition(opacity: animation, child: child),
                transitionDuration: const Duration(milliseconds: 1000),
              ));
        }
      } else {
        Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => const LoginScreen(),
              transitionsBuilder: (_, animation, __, child) =>
                  FadeTransition(opacity: animation, child: child),
              transitionDuration: const Duration(milliseconds: 1000),
            ));
      }
    }

    return Scaffold(
      backgroundColor: Colors.deepOrange,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('BY MP'),
            const Image(
              image: AssetImage('assets/bechef_logo.png'),
              height: 200,
              width: 200,
            ),
            const CircularProgressIndicator.adaptive(
              backgroundColor: Colors.black12,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.black54),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text('Cargando'),
            FutureBuilder(
              builder: (context, snapshot) => const Text(''),
              future: changeScreen(),
            ),
          ],
        ),
      ),
    );
  }
}
