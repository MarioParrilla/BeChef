
import 'package:be_chef_proyect/providers/data_profile_provider.dart';
import 'package:be_chef_proyect/services/services.dart';
import 'package:flutter/material.dart';
import 'package:be_chef_proyect/screens/screens.dart';
import 'package:provider/provider.dart';

class InitScreen extends StatelessWidget {

  const InitScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context, listen: false);
    final dataUserLoggedService = Provider.of<DataUserLoggedService>(context, listen: false);
    final dataProfileProvider = Provider.of<DataProfileProvider>(context, listen: false);

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

        Future.microtask(() async {

          if(snapshot.data! != ''){
            dynamic username = await dataUserLoggedService.getUsername();

            if ( username != null ) {
              dataProfileProvider.username = username;
              Navigator.pushReplacement(context, PageRouteBuilder(
                pageBuilder: (_, __, ___) => const HomeScreen(),
                transitionDuration: const Duration(seconds: 0),
              ));
            }
            else{
              authService.logout();
              Navigator.pushReplacement(context, PageRouteBuilder(
                pageBuilder: (_, __, ___) => const LoginScreen(),
                transitionDuration: const Duration(seconds: 0),
              ));
            }

          }
          else{
            Navigator.pushReplacement(context, PageRouteBuilder(
              pageBuilder: (_, __, ___) => const LoginScreen(),
              transitionDuration: const Duration(seconds: 0),
            ));
          }
            

        });

        return Container();
      }
    );
  }
}