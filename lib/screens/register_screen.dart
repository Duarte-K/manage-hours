import 'package:flutter/material.dart';
import 'package:manage_hours/services/auth_service.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  AuthService _authService = AuthService();

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
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    FlutterLogo(size: 76),
                    SizedBox(height: 16),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: 'Insira o nome',
                      ),
                    ),
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
                    TextField(
                      obscureText: true,
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(
                        hintText: 'Confirme a senha',
                      ),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        if(_passwordController.text == _confirmPasswordController.text) {
                          // Lógica de registro
                          _authService.register(
                            email: _emailController.text,
                            password: _passwordController.text,
                            name: _nameController.text,
                            context: context,
                          ).then((result) {
                            if (result == null) {
                              // Registro bem-sucedido, redirecionar para a tela de login
                              if(!context.mounted) return;
                              Navigator.pop(context);
                            } else {
                              // Exibir mensagem de erro
                              if(!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(result), backgroundColor: Colors.red),
                              );
                            }
                          });

                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('As senhas não coincidem'), backgroundColor: Colors.red),
                          );
                        }
                      }, 
                      child: Text(  
                        'Cadastrar',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}