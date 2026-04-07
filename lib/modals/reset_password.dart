import 'package:flutter/material.dart';
import 'package:manage_hours/services/auth_service.dart';

class ResetPasswordModal extends StatefulWidget {
  const ResetPasswordModal({super.key});

  @override
  State<ResetPasswordModal> createState() => _ResetPasswordModalState();
}

class _ResetPasswordModalState extends State<ResetPasswordModal> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  AuthService _authService = AuthService();

   @override

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Recuperar senha'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Digite seu email para recuperação',
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return 'O email é obrigatório';
            }
            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
              return 'Digite um email válido';
            }
            return null;
          },
        ),
      ),
      actions: <TextButton>[
        TextButton(
          child: Text('Cancelar'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('Recuperar'),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _authService
              .resetPassword(email: _emailController.text)
              .then((String? error) {
                if(!context.mounted) return;

                Navigator.of(context).pop();

                if(error!= null){
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(error), 
                      backgroundColor: Colors.red,
                    )
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Email de recuperação enviado para ${_emailController.text}! Verifique sua caixa de entrada.'), 
                      backgroundColor: Colors.green,
                    )
                  );
                }
              });
            }
          },
        ),
      ],
    );
  }
}