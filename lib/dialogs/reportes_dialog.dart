import 'package:flutter/material.dart';
import '../dialogs/editar_producto_dialog.dart';
import '../screens/reporte_ventas_page.dart';
import '../screens/reporte_productos_page.dart';

void mostrarReporteDialog(BuildContext context) {

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          title: const Text('Elege un Reporte'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              SizedBox(
                width: 190,
                height: 40,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ReporteVentasPage(),
                      ),
                    );
                  },

                  icon: const Icon(Icons.description),
                  label: const Text("Reporte Ventas"),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: 190,
                height: 40,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ReporteVentasPage(),
                      ),
                    );
                  },

                  icon: const Icon(Icons.description),
                  label: const Text("Reporte Compras"),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: 190,
                height: 40,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ReporteProductosPage(),
                      ),
                    );
                  },

                  icon: const Icon(Icons.description),
                  label: const Text("Reporte Productos"),
                ),
              ),

            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    ),
  );
}