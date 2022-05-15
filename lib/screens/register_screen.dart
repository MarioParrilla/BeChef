import 'package:be_chef_proyect/models/models.dart';
import 'package:be_chef_proyect/services/services.dart';
import 'package:flutter/material.dart';
import 'package:be_chef_proyect/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../providers/providers.dart';
import 'screens.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
          colors: [Colors.green[900]!, Colors.green],
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(
                  height: 200,
                ),
                CardContainer(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Text('REGISTER',
                          style: Theme.of(context).textTheme.headline4),
                      const SizedBox(
                        height: 30,
                      ),
                      ChangeNotifierProvider(
                        create: (_) => LoginFormProvider(),
                        child: const _LoginForm(color: Colors.green),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                TextButton(
                    child: const Text('¿Ya tienes una cuenta?',
                        style: TextStyle(color: Colors.black54, fontSize: 18)),
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(Colors.green),
                    ),
                    onPressed: () =>
                        Navigator.of(context).pushReplacement(PageRouteBuilder(
                          pageBuilder: (_, __, ___) => const LoginScreen(),
                          transitionsBuilder: (_, animation, __, child) =>
                              FadeTransition(opacity: animation, child: child),
                          transitionDuration: const Duration(milliseconds: 200),
                        ))),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          )),
    );
  }
}

class _LoginForm extends StatelessWidget {
  final Color color;
  const _LoginForm({Key? key, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);

    return Container(
      child: Form(
          key: loginForm.formKey,
          child: Column(
            children: [
              CustomInputField(
                color: color,
                labelText: 'Correo',
                keyboardType: TextInputType.emailAddress,
                hintText: 'user@gmail.com',
                icon: Icons.supervised_user_circle,
                validator: (String value) {
                  String pattern =
                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                  RegExp regExp = RegExp(pattern);
                  return regExp.hasMatch(value)
                      ? null
                      : 'Debe ser un email valido';
                },
                onChange: (String value) => loginForm.email = value,
              ),
              CustomInputField(
                color: color,
                labelText: 'Contraseña',
                hintText: '******',
                icon: Icons.lock,
                isPassword: true,
                validator: (String value) => value.length > 4
                    ? null
                    : 'Debe contener más de 5 caracteres',
                onChange: (String value) => loginForm.password = value,
              ),
              CustomInputField(
                color: color,
                labelText: 'Repetir Contraseña',
                hintText: '******',
                icon: Icons.lock,
                isPassword: true,
                validator: (String value) => value.length > 4
                    ? value == loginForm.password
                        ? null
                        : 'La contraseña debe coincidir'
                    : 'Debe contener más de 5 caracteres',
                onChange: (String value) => {},
              ),
              const SizedBox(height: 30),
              MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: color,
                  disabledColor: Colors.grey,
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 80, vertical: 15),
                      child: Text(
                        loginForm.isLoading ? 'Espere' : 'Registrarse',
                        style: const TextStyle(color: Colors.white),
                      )),
                  onPressed: loginForm.isLoading
                      ? null
                      : () async {
                          FocusScope.of(context).unfocus();
                          final authService =
                              Provider.of<AuthService>(context, listen: false);
                          final dataProfileProvider =
                              Provider.of<DataProfileProvider>(context,
                                  listen: false);

                          if (!loginForm.isValidForm()) return;

                          loginForm.isLoading = true;

                          final dynamic createdUser =
                              await authService.createUser(
                                  context, loginForm.email, loginForm.password);

                          if (createdUser.runtimeType == User) {
                            dataProfileProvider.username = createdUser.username;
                            dataProfileProvider.description =
                                createdUser.description;
                            dataProfileProvider.urlImg =
                                createdUser.urlImg ?? '';
                            Navigator.of(context)
                                .pushReplacement(PageRouteBuilder(
                              pageBuilder: (_, __, ___) => const HomeScreen(),
                              transitionsBuilder: (_, animation, __, child) =>
                                  FadeTransition(
                                      opacity: animation, child: child),
                              transitionDuration:
                                  const Duration(milliseconds: 700),
                            ));
                          } else {
                            NotificationsService.showSnackBar(
                                'Registro de la cuenta incorrecto');
                            loginForm.isLoading = false;
                          }
                        }),
            ],
          )),
    );
  }
}
