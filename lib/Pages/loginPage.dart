import 'dart:ui';

import 'package:flame/components/button.dart';
import 'package:flame/components/text_field.dart';
import 'package:flutter/material.dart';

class loginPage extends StatefulWidget {
  final Function()? onTap;

  const loginPage({super.key, required this.onTap});

  @override
  State<loginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<loginPage> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
       // resizeToAvoidBottomInset: true,
      /// 🔥 Gradient Background
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF000000),
              Color(0xFF0D0C0B),
              Color(0xFF020202),
            ],
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
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
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
                        MyButton(
                          onTap: () {},
                          text: 'Sign in',
                        ),

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
                                    color: Colors.black.withOpacity(.2),
                                  )
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
                                    color: Colors.black.withOpacity(.2),
                                  )
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
              ),),
            ),
          ),
        ),
      ),
    );
  }
}