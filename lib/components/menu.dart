import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:manage_hours/modals/delete_account.dart';
import 'package:manage_hours/services/auth_service.dart';

class Menu extends StatelessWidget {
  final User user;

  const Menu({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.manage_accounts_rounded,
                size: 48,
              ),
            ),
            accountName: Text(user.displayName != null ? user.displayName! : ''), 
            accountEmail: Text(user.email!),
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Sair'),
            onTap: () {
              AuthService().logout();
            },
          ),
          ListTile(
            leading: Icon(Icons.assignment_ind_rounded),
            title: Text('Excluir conta'),
            onTap: () {
              showDialog(
                context: context, builder: (context) {
                  return DeleteAccountModal();
                }
              );
            },
          ),
        ],
      ),
    );
  }
}