import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/correo_service.dart';

class CambiarCorreoPage extends StatefulWidget {
  const CambiarCorreoPage({super.key});

  @override
  State<CambiarCorreoPage> createState() => _CambiarCorreoPageState();
}

class _CambiarCorreoPageState extends State<CambiarCorreoPage> {
  final _nuevoCorreoCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool cargando = false;

  Future<void> cambiarCorreo() async {
    print('ENTRÉ A cambiarCorreo()');
    if (_nuevoCorreoCtrl.text.isEmpty || _passwordCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa todos los campos')),
      );
      return;
    }

    setState(() => cargando = true);

    try {
      await CorreoService.cambiarCorreo(
        nuevoCorreo: _nuevoCorreoCtrl.text,
        password: _passwordCtrl.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Correo actualizado correctamente')),
      );

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      String msg = 'Error al cambiar correo';

      if (e.code == 'wrong-password') {
        msg = 'Contraseña incorrecta';
      } else if (e.code == 'email-already-in-use') {
        msg = 'Ese correo ya está en uso';
      } else if (e.code == 'requires-recent-login') {
        msg = 'Vuelve a iniciar sesión';
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(msg)));
    } finally {
      setState(() => cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    print('BUILD CambiarCorreoPage');
    return Scaffold(
      appBar: AppBar(title: const Text('Cambiar correo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nuevoCorreoCtrl,
              decoration:
              const InputDecoration(labelText: 'Nuevo correo'),
            ),
            TextField(
              controller: _passwordCtrl,
              obscureText: true,
              decoration: const InputDecoration(
                  labelText: 'Contraseña actual'),
            ),
            const SizedBox(height: 20),

            cargando
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: cambiarCorreo,
              child: const Text('Guardar cambios'),
            ),
          ],
        ),
      ),
    );
  }
}
