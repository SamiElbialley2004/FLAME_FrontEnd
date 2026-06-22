import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart'; // Add this
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart'; // Add this
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

  // Added loading state to prevent double clicks and show progress
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  // Helper to show errors
  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.deepOrange,
      ),
    );
  }

  // Standard Email/Pass Sign Up
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

    setState(() => isLoading = true);
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      _showError(e.message ?? 'Registration failed.');
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  // GOOGLE SIGN IN LOGIC
  Future<void> signInWithGoogle() async {
    setState(() => isLoading = true);
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      if (googleAuth != null) {
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await FirebaseAuth.instance.signInWithCredential(credential);
      }
    } catch (e) {
      _showError("Google Sign-In failed.");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  // FACEBOOK SIGN IN LOGIC
  // FACEBOOK SIGN IN LOGIC
  Future<void> signInWithFacebook() async {
    setState(() => isLoading = true);
    try {
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        // CHANGED: result.accessToken!.token instead of tokenString
        final credential = FacebookAuthProvider.credential(result.accessToken!.token);
        await FirebaseAuth.instance.signInWithCredential(credential);
      }
    } catch (e) {
      _showError("Facebook Sign-In failed.");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          Image.asset(
                            'assets/images/FLAME_LOGO.png',
                            width: 140,
                            height: 140,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Let's create a new account for you",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                          const SizedBox(height: 25),
                          MyTextField(
                            controller: emailController,
                            hintText: 'EMAIL',
                            obscureText: false,
                          ),
                          const SizedBox(height: 20),
                          MyTextField(
                            controller: passwordController,
                            hintText: 'PASSWORD',
                            obscureText: true,
                          ),
                          const SizedBox(height: 20),
                          MyTextField(
                            controller: confirmPasswordController,
                            hintText: 'Confirm PASSWORD',
                            obscureText: true,
                          ),
                          const SizedBox(height: 30),

                          // Conditional Loading UI
                          isLoading
                              ? const CircularProgressIndicator(color: Colors.deepOrange)
                              : MyButton(onTap: signUp, text: 'Sign up'),

                          const SizedBox(height: 25),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Google Button
                              GestureDetector(
                                onTap: signInWithGoogle,
                                child: _SocialTile(
                                  icon: Icons.g_mobiledata,
                                  color: Colors.red,
                                  size: 35,
                                ),
                              ),
                              const SizedBox(width: 25),
                              // Facebook Button
                              GestureDetector(
                                onTap: signInWithFacebook,
                                child: _SocialTile(
                                  icon: Icons.facebook,
                                  color: Colors.blue,
                                  size: 28,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 25),
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

// Reusable UI for social icons
class _SocialTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;

  const _SocialTile({required this.icon, required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Icon(icon, color: color, size: size),
    );
  }
}