import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/perfil_service.dart';

class EditarPerfilPage extends StatefulWidget {
  const EditarPerfilPage({super.key});

  @override
  State<EditarPerfilPage> createState() => _EditarPerfilPageState();
}

class _EditarPerfilPageState extends State<EditarPerfilPage> {
  final _nombreCtrl = TextEditingController();
  final _usuarioCtrl = TextEditingController();
  final _edadCtrl = TextEditingController();

  final User user = FirebaseAuth.instance.currentUser!;

  bool cargando = true;

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

  Future<void> cargarDatos() async {
    final data = await PerfilService.obtenerPerfil(user.uid);

    _nombreCtrl.text = data['nombre'];
    _usuarioCtrl.text = data['nombre_usuario'];
    _edadCtrl.text = data['edad'].toString();

    setState(() => cargando = false);
  }

  Future<void> guardarCambios() async {
    try {
      await PerfilService.actualizarPerfil(
        uid: user.uid,
        nombre: _nombreCtrl.text,
        usuario: _usuarioCtrl.text,
        edad: int.tryParse(_edadCtrl.text) ?? 0,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil actualizado')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (cargando) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Editar perfil')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nombreCtrl,
              decoration:
              const InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: _usuarioCtrl,
              decoration: const InputDecoration(
                  labelText: 'Nombre de usuario'),
            ),
            TextField(
              controller: _edadCtrl,
              keyboardType: TextInputType.number,
              decoration:
              const InputDecoration(labelText: 'Edad'),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: guardarCambios,
              icon: const Icon(Icons.save),
              label:
              const Text('Guardar cambios'),
            ),
          ],
        ),
      ),
    );
  }
}
