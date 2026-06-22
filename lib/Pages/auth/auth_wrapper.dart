import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../main_shell.dart';
import 'login_or_register.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const MainShell();
          } else {
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}
