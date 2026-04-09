import 'package:flutter/material.dart';
import 'package:manage_hours/services/auth_service.dart';

class DeleteAccountModal extends StatefulWidget {
  const DeleteAccountModal({super.key});

  @override
  State<DeleteAccountModal> createState() => _DeleteAccountModalState();
}

class _DeleteAccountModalState extends State<DeleteAccountModal> {
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();

   @override
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Deletar conta'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _passwordController,
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Digite sua senha',
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Campo de senha é obrigatório';
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
          child: Text('Deletar'),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _authService
              .deleteAccount(password: _passwordController.text)
              .then((String? error) {
                if(!context.mounted) return;

                Navigator.of(context).pop();

                if(error!= null){
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(error))
                  );
                }else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Conta deletada com sucesso'), 
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