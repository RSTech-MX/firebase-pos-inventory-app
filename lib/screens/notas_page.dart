import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/notas_service.dart';
import '../dialogs/nueva_nota_dialog.dart';

class NotasPage extends StatelessWidget {
  const NotasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notas'),
        backgroundColor: Colors.yellow,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => mostrarDialogAgregarNota(context),
        child: const Icon(Icons.add),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: NotasService.obtenerNota(),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No hay notas registrados'));
          }

          final notas = snapshot.data!.docs;

          return ListView.builder(
            itemCount: notas.length,
            itemBuilder: (context, index) {
              final doc = notas[index];
              final data = doc.data() as Map<String, dynamic>;

              return Card(
                margin:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text(data['titulo']),
                  subtitle: Text(
                    'contenido: ${data['contenido']}',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await NotasService.eliminarNota(doc.id);
                    },
                  ),
                  onTap: () {
                    mostrarDialogEditarNota(
                      context: context,
                      id: doc.id,
                      data: data,
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}