import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

// Importa tu CorreoProvider
import 'providers/correo_provider.dart';
import 'providers/perfil_provider.dart';

// Screens
import 'screens/auth_gate.dart';
import 'screens/home_page_demo.dart';
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CorreoProvider()),
        ChangeNotifierProvider(create: (_) => PerfilProvider()),
      ],
      child: MaterialApp(
        title: 'Pruebas de Base de Datos',
        debugShowCheckedModeBanner: false,

        home: const AuthGate(),

        //initialRoute: '/',
        routes: {
          '/home': (context) => const HomePageDemo(),
          '/welcome': (context) => const WelcomeScreen(),
        },
      ),
    );
  }
}
