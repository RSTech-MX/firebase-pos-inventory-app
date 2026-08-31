import 'package:flutter/material.dart';
import '../services/auth_service.dart';

void mostrarLoginDialog(BuildContext context) {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool obscure = true;
  bool cargando = false;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          title: const Text('Iniciar sesión'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: emailCtrl,
                decoration: const InputDecoration(labelText: 'Correo'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: passCtrl,
                obscureText: obscure,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscure ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() => obscure = !obscure);
                    },
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            cargando
                ? const CircularProgressIndicator()
                : ElevatedButton(
              child: const Text('Entrar'),
              onPressed: () async {
                setState(() => cargando = true);
                try {
                  await AuthService().login(
                    emailCtrl.text.trim(),
                    passCtrl.text.trim(),
                  );

                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, '/home');
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Error al iniciar sesión'),
                    ),
                  );
                } finally {
                  setState(() => cargando = false);
                }
              },
            ),
          ],
        );
      },
    ),
  );
}
