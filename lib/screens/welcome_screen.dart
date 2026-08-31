import 'package:flutter/material.dart';
import '../dialogs/login_dialog.dart';
import 'registrar_usuario_page.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shopping_cart, size: 100),
            const SizedBox(height: 24),

            const Text(
              'Bienvenido',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            const Text(
              'Registra compras, guarda comprobantes '
                  'y administra tu información fácilmente.',
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 40),

            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RegistrarUsuarioPage(),
                  ),
                );
              },
              icon: const Icon(Icons.person_add),
              label: const Text('REGISTRAR NUEVO USUARIO'),
            ),

            const SizedBox(height: 12),

            ElevatedButton.icon(
              onPressed: () => mostrarLoginDialog(context),
              icon: const Icon(Icons.login),
              label: const Text('Iniciar sesión'),
            ),

            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/home');
              },
              child: const Text('Entrar sin cuenta'),
            ),
          ],
        ),
      ),
    );
  }
}