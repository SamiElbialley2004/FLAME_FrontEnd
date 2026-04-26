import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flame/components/button.dart';
import 'package:flame/components/text_field.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> signUp() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showError('Please fill in all fields.');
      return;
    }

    if (password != confirmPassword) {
      _showError('Passwords do not match.');
      return;
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      _showError(e.message ?? 'Registration failed. Please try again.');
    } catch (_) {
      _showError('Something went wrong. Please try again.');
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

              /// حل مشكلة overflow
              child: SingleChildScrollView(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),

                  /// Glass Effect
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
                          /// LOGO
                          Image.asset(
                            'images/FLAME_LOGO.png',
                            width: 140,
                            height: 140,
                          ),

                          const SizedBox(height: 10),

                          const Text(
                            "Let's create a new account for you",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),

                          const SizedBox(height: 25),

                          /// EMAIL
                          MyTextField(
                            controller: emailController,
                            hintText: 'EMAIL',
                            obscureText: false,
                          ),

                          const SizedBox(height: 20),

                          /// PASSWORD
                          MyTextField(
                            controller: passwordController,

                            hintText: 'PASSWORD',
                            obscureText: true,
                          ),

                          const SizedBox(height: 20),

                          /// CONFIRM PASSWORD
                          MyTextField(
                            controller: confirmPasswordController,
                            hintText: 'Confirm PASSWORD',
                            obscureText: true,
                          ),

                          const SizedBox(height: 30),

                          /// SIGN UP BUTTON
                          MyButton(onTap: signUp, text: 'Sign up'),

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
                                      color: Colors.black.withValues(alpha: .3),
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
                                      color: Colors.black.withValues(alpha: .3),
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

                          /// LOGIN LINK
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Already have an account?',
                                style: TextStyle(color: Colors.white),
                              ),

                              const SizedBox(width: 4),

                              GestureDetector(
                                onTap: widget.onTap,
                                child: const Text(
                                  'Login Page',
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
