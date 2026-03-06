import 'package:flutter/material.dart';
import 'package:flame/Pages/loginPage.dart';
import 'package:flame/Pages/registerPage.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {

  // Initially show the login page
  bool showLoginPage = true;

  // Toggle between login and register page
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {

    // Simply return the appropriate page
    if (showLoginPage) {
      return loginPage(onTap: togglePages);
    } else {
      return registerPage(onTap: togglePages);
    }
  }
}