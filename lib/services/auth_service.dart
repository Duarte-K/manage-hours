import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          return 'Usuário não encontrado. Verifique o email e tente novamente.';
        case 'wrong-password':
          return 'Senha incorreta. Tente novamente.';
      }
      return e.code;
    } catch (e) {
      return 'Ocorreu um erro inesperado. Tente novamente.'; // Erro genérico
    }

    return null;
  }

  Future<String?> register({
    required String email,
    required String password,
    required String name,
    required BuildContext context,
  }) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      await userCredential.user!.updateDisplayName(name);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          return 'O email já está em uso. Tente outro email.';
        case 'invalid-email':
          return 'O email fornecido é inválido. Verifique e tente novamente.';
      }
      return e.code;
    } catch (e) {
      return 'Ocorreu um erro inesperado. Tente novamente.'; // Erro genérico
    }

    return null;
  }

  Future<String?> resetPassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          return 'Usuário não encontrado. Verifique o email e tente novamente.';
      }
      return e.code;
    } catch (e) {
      return 'Ocorreu um erro inesperado. Tente novamente.'; // Erro genérico
    }

    return null;
  }

  Future<String?> logout() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      return e.code;
    } catch (e) {
      return 'Ocorreu um erro inesperado. Tente novamente.'; // Erro genérico
    }
    return null;
  }

  Future<String?> deleteAccount({required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: _firebaseAuth.currentUser!.email!,
        password: password,
      );

      await _firebaseAuth.currentUser!.delete();
    } on FirebaseAuthException catch (e) {
      return e.code;
    } catch (e) {
      return 'Ocorreu um erro inesperado. Tente novamente.'; // Erro genérico
    }

    return null;
  }
}
