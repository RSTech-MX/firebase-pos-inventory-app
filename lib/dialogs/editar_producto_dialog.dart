import 'package:flutter/material.dart';
import '../services/producto_service.dart';

// =============================
// Dialog Agregar Producto
// =============================
Future<void> mostrarDialogAgregarProducto(BuildContext context) async {
  final nombreCtrl = TextEditingController();
  final costoCtrl = TextEditingController();
  final precioCtrl = TextEditingController();
  final cantidadCtrl = TextEditingController();

  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Agregar producto'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nombreCtrl,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: costoCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Costo'),
            ),
            TextField(
              controller: precioCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Precio'),
            ),
            TextField(
              controller: cantidadCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Cantidad'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            child: const Text('Guardar'),
            onPressed: () async {
              await ProductoService.agregarProducto(
                nombre: nombreCtrl.text,
                costo: double.parse(costoCtrl.text),
                precio: double.parse(precioCtrl.text),
                cantidad: int.parse(cantidadCtrl.text),
              );
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}

// =============================
// Dialog Editar Producto
// =============================
Future<void> mostrarDialogEditarProducto({
  required BuildContext context,
  required String id,
  required Map<String, dynamic> data,
}) async {
  final nombreCtrl = TextEditingController(text: data['nombre']);
  final costoCtrl = TextEditingController(text: data['costo'].toString());
  final precioCtrl = TextEditingController(text: data['precio'].toString());
  final cantidadCtrl =
  TextEditingController(text: data['cantidad'].toString());

  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Editar producto'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nombreCtrl,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: costoCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Costo'),
            ),
            TextField(
              controller: precioCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Precio'),
            ),
            TextField(
              controller: cantidadCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Cantidad'),
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
              await ProductoService.actualizarProducto(
                id: id,
                nombre: nombreCtrl.text,
                costo: double.parse(costoCtrl.text),
                precio: double.parse(precioCtrl.text),
                cantidad: int.parse(cantidadCtrl.text),
              );
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}

