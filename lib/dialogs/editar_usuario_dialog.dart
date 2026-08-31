import 'package:flutter/material.dart';
import '../services/usuario_service.dart';

Future<void> mostrarDialogEditarUsuario({
  required BuildContext context,
  required String uid,
  required Map<String, dynamic> data,
}) async {
  final nombreCtrl = TextEditingController(text: data['nombre']);
  final nombreUsuarioCtrl =
  TextEditingController(text: data['nombre_usuario']);
  final edadCtrl =
  TextEditingController(text: data['edad'].toString());

  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Editar Usuario'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nombreCtrl,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: nombreUsuarioCtrl,
              decoration:
              const InputDecoration(labelText: 'Nombre de usuario'),
            ),
            TextField(
              controller: edadCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Edad'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            child: const Text('Actualizar'),
            onPressed: () async {
              await UsuarioService.actualizarUsuario(
                uid: uid,
                nombre: nombreCtrl.text,
                nombreUsuario: nombreUsuarioCtrl.text,
                edad: int.parse(edadCtrl.text),
              );
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}
