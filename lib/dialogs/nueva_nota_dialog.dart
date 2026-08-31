import 'package:flutter/material.dart';
import '../services/notas_service.dart';
import '../widgets/selector_color_nota.dart';

// =============================
// Dialog Agregar Nota
// =============================
Future<void> mostrarDialogAgregarNota(BuildContext context) async {
  final tituloCtrl = TextEditingController();
  final contenidoCtrl = TextEditingController();
  int colorSeleccionado = Colors.yellow.value;

  await showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Agregar nota'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: tituloCtrl,
                    decoration: const InputDecoration(labelText: 'Titulo'),
                  ),
                  TextField(
                    controller: contenidoCtrl,
                    decoration: const InputDecoration(labelText: 'Contenido'),
                  ),
                  const SizedBox(height: 10),
                  selectorColor(
                    colorSeleccionado: colorSeleccionado,
                    onColorSelected: (color) {
                      setState(() {
                        colorSeleccionado = color;
                      });
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                child: const Text('Guardar'),
                onPressed: () async {
                  await NotasService.agregarNota(
                    titulo: tituloCtrl.text,
                    contenido: contenidoCtrl.text,
                    color: colorSeleccionado,
                  );
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    },
  );
}


// =============================
// Dialog Editar Nota
// =============================
Future<void> mostrarDialogEditarNota({
  required BuildContext context,
  required String id,
  required Map<String, dynamic> data,
}) async {
  final tituloCtrl = TextEditingController(text: data['titulo']);
  final contenidoCtrl = TextEditingController(text: data['contenido']);
  int colorSeleccionado = data['color'] ?? Colors.yellow.value;

  await showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Editar nota'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: tituloCtrl,
                    decoration: const InputDecoration(labelText: 'Titulo'),
                  ),
                  TextField(
                    controller: contenidoCtrl,
                    decoration: const InputDecoration(labelText: 'Contenido'),
                  ),
                  const SizedBox(height: 10),
                  selectorColor(
                    colorSeleccionado: colorSeleccionado,
                    onColorSelected: (color) {
                      setState(() {
                        colorSeleccionado = color;
                      });
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                child: const Text('Actualizar'),
                onPressed: () async {
                  await NotasService.actualizarNota(
                    id: id,
                    titulo: tituloCtrl.text,
                    contenido: contenidoCtrl.text,
                    color: colorSeleccionado,
                  );
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    },
  );
}
