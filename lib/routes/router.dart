import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:manage_hours/screens/home_screen.dart';
import 'package:manage_hours/screens/login_screen.dart';
class Route extends StatelessWidget {
  const Route({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.userChanges(), 
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          if(snapshot.hasData){
            return HomeScreen(user: snapshot.data!);
          } else {
            return LoginScreen();
          }
        }
      }
    );
  }
}