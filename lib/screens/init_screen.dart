
import 'package:be_chef_proyect/services/services.dart';
import 'package:flutter/material.dart';
import 'package:be_chef_proyect/screens/screens.dart';
import 'package:provider/provider.dart';

class InitScreen extends StatelessWidget {

  const InitScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context, listen: false);

    return FutureBuilder(
      future: authService.readToken(duration: 3),
      builder: ( _ , AsyncSnapshot<String> snapshot) {
        if(!snapshot.hasData){
          return Scaffold(
            backgroundColor: Colors.deepOrange,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('BY MP'),
                    Image(
                      image: AssetImage('assets/bechef_logo.png'),
                      height: 200,
                      width: 200,
                    ),
                    CircularProgressIndicator.adaptive(
                      backgroundColor: Colors.black12,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black54)
                    ),
                    SizedBox(height: 10,),
                    Text('Cargando'),
                  ],
                ),
              )
            );
        }

        Future.microtask((){

          snapshot.data! != ''
          ? Navigator.pushReplacement(context, PageRouteBuilder(
            pageBuilder: (_, __, ___) => const HomeScreen(),
            transitionDuration: const Duration(seconds: 0),
            ))
          : Navigator.pushReplacement(context, PageRouteBuilder(
            pageBuilder: (_, __, ___) => const LoginScreen(),
            transitionDuration: const Duration(seconds: 0),
            ));
        });

        return Container();
      }
    );
  }
}