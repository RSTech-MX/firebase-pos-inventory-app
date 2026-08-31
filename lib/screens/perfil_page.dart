import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/perfil_item.dart';
import '../widgets/dialog_cambiar_password.dart';
import 'editar_perfil_page.dart';
import 'cambiar_correo_page.dart';

class PerfilPage extends StatelessWidget {
  const PerfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    // Seguridad extra
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('No hay usuario autenticado')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Mi perfil'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('usuarios')
            .doc(user.uid)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(
                child: Text('No se encontraron datos'));
          }

          final data =
          snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PerfilItem(
                    titulo: 'Nombre',
                    valor: data['nombre']),
                PerfilItem(
                    titulo: 'Usuario',
                    valor: data['nombre_usuario']),
                PerfilItem(
                    titulo: 'Correo',
                    valor: data['correo']),
                PerfilItem(
                    titulo: 'Edad',
                    valor: data['edad'].toString()),

                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                        const EditarPerfilPage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Editar perfil'),
                ),

                ElevatedButton.icon(
                  onPressed: () =>
                      DialogCambiarPassword.mostrar(context),
                  icon: const Icon(Icons.lock),
                  label:
                  const Text('Cambiar contraseña'),
                ),

                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                        const CambiarCorreoPage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.email),
                  label: const Text('Cambiar correo'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
