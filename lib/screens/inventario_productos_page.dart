import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/producto_service.dart';
import '../dialogs/editar_producto_dialog.dart';

class InventarioProductosPage extends StatelessWidget {
  const InventarioProductosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventario de productos'),
        backgroundColor: Colors.blue,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => mostrarDialogAgregarProducto(context),
        child: const Icon(Icons.add),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: ProductoService.obtenerProductos(),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No hay productos registrados'));
          }

          final productos = snapshot.data!.docs;

          return ListView.builder(
            itemCount: productos.length,
            itemBuilder: (context, index) {
              final doc = productos[index];
              final data = doc.data() as Map<String, dynamic>;

              return Card(
                margin:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text(data['nombre']),
                  subtitle: Text(
                    'Costo: \$${data['costo']} | Precio: \$${data['precio']} | Cantidad: ${data['cantidad']}',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await ProductoService.eliminarProducto(doc.id);
                    },
                  ),
                  onTap: () {
                    mostrarDialogEditarProducto(
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
