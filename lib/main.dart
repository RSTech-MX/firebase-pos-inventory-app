import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

// Screens
import 'screens/auth_gate.dart';
import 'screens/home_page.dart';
import 'screens/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pruebas de Base de Datos',
      debugShowCheckedModeBanner: false,

      // 🔥 ÚNICO punto de entrada
      home: const AuthGate(),

      //initialRoute: '/',

      routes: {
        '/home': (context) => const HomePage(),
        '/welcome': (context) => const WelcomeScreen(),
      },
    );
  }
}

