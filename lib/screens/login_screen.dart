// ignore_for_file: await_only_futures

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:manage_hours/modals/reset_password.dart';
import 'package:manage_hours/screens/register_screen.dart';
import 'package:manage_hours/services/auth_service.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
      body: Container(
        color: Colors.blue,
        padding: EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    FlutterLogo(size: 76),
                    SizedBox(height: 16),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: 'Insira o email',
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      obscureText: true,
                      controller: _passwordController,
                      decoration: InputDecoration(
                        hintText: 'Insira a senha',
                      ),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        _authService.login(
                          email: _emailController.text, 
                          password: _passwordController.text,
                          context: context
                        ).then((String? error ) {
                          if(error != null){
                            if(!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(error), 
                                backgroundColor: Colors.red,
                              )
                            );
                          }
                        });
                      },
                      child: Text(  
                        'Entrar',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        signinWithGoogle();
                      },
                      child: Text(  
                        'Entrar com Google',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RegisterScreen()),
                        );
                      }, 
                      child: Text('Ainda não tem uma conta? Cadastre-se aqui'),
                    ),
                    TextButton(
                      onPressed: () {
                        showDialog(
                          context: context, 
                          builder: (BuildContext context) {
                            return ResetPasswordModal();
                          }
                        );
                      }, 
                      child: Text('Esqueceu sua senha? Recupere aqui'),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  
   Future<UserCredential>signinWithGoogle() async{

    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}