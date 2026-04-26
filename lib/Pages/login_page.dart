import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flame/components/button.dart';
import 'package:flame/components/text_field.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> signIn() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showError('Please enter both email and password.');
      return;
    }

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      _showError(_mapLoginError(e));
    } catch (_) {
      _showError('Something went wrong. Please try again.');
    }
  }

  String _mapLoginError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Email format is invalid.';
      case 'invalid-credential':
      case 'wrong-password':
      case 'user-not-found':
        return 'Invalid email or password.';
      case 'too-many-requests':
        return 'Too many attempts. Try again later.';
      case 'network-request-failed':
        return 'Network error. Check your connection and try again.';
      default:
        return e.message ?? 'Login failed. Please try again.';
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: true,
      /// 🔥 Gradient Background
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF000000), Color(0xFF0D0C0B), Color(0xFF020202)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),

              child: SingleChildScrollView(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),

                  /// ✨ Glass Effect
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),

                    child: Container(
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                      ),

                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          /// 🔥 LOGO
                          Image.asset(
                            'images/FLAME_LOGO.png',
                            width: 90,
                            height: 90,
                          ),

                          const SizedBox(height: 20),

                          const Text(
                            "Pass the FLAME",
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1,
                            ),
                          ),

                          const SizedBox(height: 30),

                          /// EMAIL
                          MyTextField(
                            controller: emailController,
                            hintText: 'EMAIL',
                            obscureText: false,
                          ),

                          const SizedBox(height: 12),

                          /// PASSWORD
                          MyTextField(
                            controller: passwordController,
                            hintText: 'PASSWORD',
                            obscureText: true,
                          ),

                          const SizedBox(height: 20),

                          /// SIGN IN BUTTON
                          MyButton(onTap: signIn, text: 'Sign in'),

                          const SizedBox(height: 25),

                          /// Divider
                          Row(
                            children: const [
                              Expanded(child: Divider(color: Colors.white)),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  "Or continue with",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              Expanded(child: Divider(color: Colors.white)),
                            ],
                          ),

                          const SizedBox(height: 20),

                          /// SOCIAL LOGIN
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              /// GOOGLE
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 10,
                                      color: Colors.black.withValues(alpha: .2),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.g_mobiledata,
                                  color: Colors.red,
                                  size: 35,
                                ),
                              ),

                              const SizedBox(width: 25),

                              /// FACEBOOK
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 10,
                                      color: Colors.black.withValues(alpha: .2),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.facebook,
                                  color: Colors.blue,
                                  size: 28,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 25),

                          /// REGISTER
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Not a member?',
                                style: TextStyle(color: Colors.white),
                              ),

                              const SizedBox(width: 4),

                              GestureDetector(
                                onTap: widget.onTap,
                                child: const Text(
                                  'Register now',
                                  style: TextStyle(
                                    color: Colors.deepOrange,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
