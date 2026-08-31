import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/usuario_service.dart';
import '../dialogs/editar_usuario_dialog.dart';

class UsuariosPage extends StatelessWidget {
  const UsuariosPage({super.key});

  @override
  Widget build(BuildContext context) {
    final String uidActual = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuarios'),
        backgroundColor: Colors.blue,
      ),

      body: FutureBuilder<bool>(
        future: UsuarioService.esAdmin(uidActual),
        builder: (context, rolSnapshot) {

          if (!rolSnapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final bool esAdmin = rolSnapshot.data!;

          if (!esAdmin) {
            return const Center(
              child: Text('No tienes permisos para ver esta sección'),
            );
          }

          return StreamBuilder<QuerySnapshot>(
            stream: UsuarioService.obtenerUsuarios(),
            builder: (context, snapshot) {

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No hay usuarios registrados'));
              }

              final usuarios = snapshot.data!.docs;

              return ListView.builder(
                itemCount: usuarios.length,
                itemBuilder: (context, index) {
                  final doc = usuarios[index];
                  final data = doc.data() as Map<String, dynamic>;

                  return Card(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    child: ListTile(
                      title: Text(data['nombre']),
                      subtitle: Text(
                        'Usuario: ${data['nombre_usuario']} | Edad: ${data['edad']}',
                      ),

                      trailing: FutureBuilder<bool>(
                        future: UsuarioService.esMaster(uidActual),
                        builder: (context, masterSnapshot) {

                          if (!masterSnapshot.hasData ||
                              !masterSnapshot.data!) {
                            return const SizedBox.shrink();
                          }

                          return IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              await UsuarioService.eliminarUsuario(doc.id);
                            },
                          );
                        },
                      ),

                      onTap: () {
                        mostrarDialogEditarUsuario(
                          context: context,
                          uid: doc.id,
                          data: data,
                        );
                      },
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
