import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/usuario_service.dart';

class RegistrarUsuarioPage extends StatefulWidget {
  const RegistrarUsuarioPage({super.key});

  @override
  State<RegistrarUsuarioPage> createState() =>
      _RegistrarUsuarioPageState();
}

class _RegistrarUsuarioPageState
    extends State<RegistrarUsuarioPage> {
  final TextEditingController _nombreCtrl =
  TextEditingController();
  final TextEditingController _nombreUsuarioCtrl =
  TextEditingController();
  final TextEditingController _edadCtrl =
  TextEditingController();
  final TextEditingController _correoCtrl =
  TextEditingController();
  final TextEditingController _passwordCtrl =
  TextEditingController();

  Future<void> agregarUsuario() async {
    if (_correoCtrl.text.isEmpty ||
        _passwordCtrl.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Datos inválidos')),
      );
      return;
    }

    try {
      await UsuarioService.registrarUsuario(
        nombre: _nombreCtrl.text,
        nombreUsuario: _nombreUsuarioCtrl.text,
        edad: int.tryParse(_edadCtrl.text) ?? 0,
        correo: _correoCtrl.text,
        password: _passwordCtrl.text,
      );

      _nombreCtrl.clear();
      _nombreUsuarioCtrl.clear();
      _edadCtrl.clear();
      _correoCtrl.clear();
      _passwordCtrl.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Usuario registrado correctamente'),
        ),
      );
    } on FirebaseAuthException catch (e) {
      String mensaje = 'Error al registrar';

      if (e.code == 'email-already-in-use') {
        mensaje = 'El correo ya está registrado';
      } else if (e.code == 'weak-password') {
        mensaje =
        'La contraseña debe tener al menos 6 caracteres';
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(mensaje)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar usuario')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nombreCtrl,
              decoration:
              const InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: _nombreUsuarioCtrl,
              decoration: const InputDecoration(
                  labelText: 'Nombre de Usuario'),
            ),
            TextField(
              controller: _edadCtrl,
              decoration:
              const InputDecoration(labelText: 'Edad'),
            ),
            TextField(
              controller: _correoCtrl,
              decoration:
              const InputDecoration(labelText: 'Correo'),
            ),
            TextField(
              controller: _passwordCtrl,
              obscureText: true,
              decoration:
              const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: agregarUsuario,
              style: ButtonStyle(
                backgroundColor:
                MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed)) {
                      return Colors.blue.shade700;
                    }
                    return Colors.blue;
                  },
                ),
                foregroundColor:
                MaterialStateProperty.all(Colors.white),
                padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(
                      horizontal: 30, vertical: 16),
                ),
                textStyle: MaterialStateProperty.all(
                  const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                elevation:
                MaterialStateProperty.resolveWith<double>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed)) {
                      return 12;
                    }
                    return 6;
                  },
                ),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              child: const Text('Agregar usuario'),
            ),
          ],
        ),
      ),
    );
  }
}

