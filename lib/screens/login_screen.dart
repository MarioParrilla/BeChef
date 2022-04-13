import 'package:be_chef_proyect/services/services.dart';
import 'package:flutter/material.dart';
import 'package:be_chef_proyect/providers/providers.dart';
import 'package:be_chef_proyect/widgets/widgets.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {

  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        colors: [Colors.orange[900]!, Colors.deepOrange],
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [

              const SizedBox( height: 200, ),
              CardContainer( 
                child: Column(
                  children: [

                    const SizedBox( height: 10, ),
                    Text('LOGIN', style: Theme.of(context).textTheme.headline4),
                    const SizedBox( height: 30, ),

                    ChangeNotifierProvider(
                      create: (_) => LoginFormProvider(),
                      child: const _LoginForm(color: Colors.deepOrange),
                    ),
                    
                  ],
                ),
              ),
              const SizedBox( height: 50, ),
              TextButton(
                child: const Text('¿No tienes una cuenta?', style: TextStyle(color: Colors.black54, fontSize: 18)),
                  style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.deepOrange),
                ),
                onPressed: () => Navigator.of(context).pushReplacementNamed('register'),
              ),
              const SizedBox( height: 15, ),

            ],
          ),
        )
      ),
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
              color: color, labelText: 'Correo',
              hintText: 'user@gmail.com', icon: Icons.supervised_user_circle,
              keyboardType: TextInputType.emailAddress,
              validator: ( String value ) {
                String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regExp = RegExp(pattern);
                return regExp.hasMatch(value) ? null : 'Debe ser un email valido';
              },
              onChange: ( String value ) => loginForm.email = value,
            ),

            CustomInputField(
              color: color, labelText: 'Contraseña', 
              hintText: '******', icon: Icons.lock, isPassword: true,
              validator: ( String value ) => value.length > 4 ? null : 'Debe contener más de 4 caracteres',
              onChange: ( String value ) => loginForm.password = value,
            ),

            const SizedBox(height: 30),

            MaterialButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              color: color,
              disabledColor: Colors.grey,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                child: Text(
                  loginForm.isLoading
                  ? 'Espere'
                  : 'Ingresar', 
                  style: const TextStyle(color: Colors.white),
                )
              ),
              onPressed: loginForm.isLoading ? null : () async{
                FocusScope.of(context).unfocus();

                if(!loginForm.isValidForm()) return;

                loginForm.isLoading = true;

                FocusScope.of(context).unfocus();
                final authService = Provider.of<AuthService>(context, listen: false);

                if(!loginForm.isValidForm()) return;

                loginForm.isLoading = true;

                final String? errorMessage = await authService.login(loginForm.email, loginForm.password);

                
                if(errorMessage == null) {
                  Navigator.of(context).pushReplacementNamed('home');
                } else{
                  NotificationsService.showSnackBar('Inicio de sesión incorrecto');
                  loginForm.isLoading = false;
                }

              } 
            ),
          ],
        )
      ),
    );
  }
}