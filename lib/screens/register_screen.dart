import 'package:be_chef_proyect/services/services.dart';
import 'package:flutter/material.dart';
import 'package:be_chef_proyect/providers/login_form_provider.dart';
import 'package:be_chef_proyect/widgets/widgets.dart';
import 'package:provider/provider.dart';

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

              const SizedBox( height: 200, ),
              CardContainer( 
                child: Column(
                  children: [

                    const SizedBox( height: 10, ),
                    Text('REGISTER', style: Theme.of(context).textTheme.headline4),
                    const SizedBox( height: 30, ),

                    ChangeNotifierProvider(
                      create: (_) => LoginFormProvider(),
                      child: const _LoginForm(color: Colors.green),
                    ),
                    
                  ],
                ),
              ),
              const SizedBox( height: 50, ),
              TextButton(
                child: const Text('¿Ya tienes una cuenta?', style: TextStyle(color: Colors.black54, fontSize: 18)),
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.green),
                ),
                onPressed: () => Navigator.of(context).pushReplacementNamed('login'),
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
              keyboardType: TextInputType.emailAddress,
              hintText: 'user@gmail.com', icon: Icons.supervised_user_circle,
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
              validator: ( String value ) => value.length > 4 ? null : 'Debe contener más de 5 caracteres',
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
                  : 'Registrarse', 
                  style: const TextStyle(color: Colors.white),
                )
              ),
              onPressed: loginForm.isLoading ? null : () async{

                FocusScope.of(context).unfocus();
                final authService = Provider.of<AuthService>(context, listen: false);

                if(!loginForm.isValidForm()) return;

                loginForm.isLoading = true;

                final String? errorMessage = await authService.createUser(loginForm.email, loginForm.password);
                
                if(errorMessage == null) {
                  Navigator.of(context).popAndPushNamed('home');
                } else{
                  NotificationsService.showSnackBar('Registro de la cuenta incorrecto');
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