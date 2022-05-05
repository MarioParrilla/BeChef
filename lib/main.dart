import 'package:be_chef_proyect/screens/screens.dart';
import 'package:be_chef_proyect/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:be_chef_proyect/providers//providers.dart';

Future<void> main() async {
  runApp(const AppState());
}

class AppState extends StatelessWidget {

  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => RecipeService()),
        ChangeNotifierProvider(create: (_) => DataProfileProvider()),
        ChangeNotifierProvider(create: (_) => LoggedUserRecipesProvider()),
        ChangeNotifierProvider(create: (_) => DataUserLoggedService()),
        ChangeNotifierProvider(create: (_) => DataUserLoggedService()),
        ChangeNotifierProvider(create: (_) => RecipeProvider()),
      ],
      child: const BeChefApp(),
    );
  }
}

class BeChefApp extends StatelessWidget {

  const BeChefApp({Key? key}) : super(key: key);

  static Route<dynamic> onGenerateRoute(RouteSettings settings){
    return MaterialPageRoute(
      builder: (context) => const InitScreen()
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'init',
      routes: {
        'init': ( _ ) => const InitScreen(),
        'home': ( _ ) => const HomeScreen(),
        'login': ( _ ) => const LoginScreen(),
        'register': ( _ ) => const RegisterScreen(),
        'infoRecipe': ( _ ) => const InfoRecipeScreen(),
        'editProfile': ( _ ) => const EditProfileScreen(),
      },
      onGenerateRoute: (settings) => onGenerateRoute(settings),
      scaffoldMessengerKey: NotificationsService.messagerKey,
    );
  }
}