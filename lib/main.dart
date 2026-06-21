import 'package:firebase_core/firebase_core.dart';
import 'package:flame/firebase_options.dart';
import 'package:flutter/material.dart';
import 'pages/auth/auth_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flame',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFFFB923C),
        scaffoldBackgroundColor: const Color(0xFF09090B),
      ),
      home: const AuthPage(),
    );
  }
}
