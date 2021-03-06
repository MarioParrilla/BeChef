import 'package:be_chef_proyect/providers/search_provider.dart';
import 'package:be_chef_proyect/screens/screens.dart';
import 'package:be_chef_proyect/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:be_chef_proyect/providers//providers.dart';
import 'providers/list_category_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
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
        ChangeNotifierProvider(create: (_) => ListCategoryProvider()),
        ChangeNotifierProvider(create: (_) => CategoryService()),
        ChangeNotifierProvider(create: (_) => UserService()),
        ChangeNotifierProvider(create: (_) => SearchProvider()),
        ChangeNotifierProvider(create: (_) => LoginFormProvider()),
      ],
      child: const BeChefApp(),
    );
  }
}

class BeChefApp extends StatelessWidget {
  const BeChefApp({Key? key}) : super(key: key);

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(builder: (context) => const InitScreen());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'init',
      routes: {
        'init': (_) => const InitScreen(),
        'login': (_) => const LoginScreen(),
        'home': (_) => const HomeScreen(),
        'search': (_) => const SearchScreen(),
        'register': (_) => const RegisterScreen(),
        'editProfile': (_) => const EditProfileScreen(),
      },
      onGenerateRoute: (settings) => onGenerateRoute(settings),
      scaffoldMessengerKey: NotificationsService.messagerKey,
    );
  }
}
