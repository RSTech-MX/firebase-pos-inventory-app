import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/producto_service.dart';

class RegistrarProductoPage extends StatefulWidget {
  const RegistrarProductoPage({super.key});

  @override
  State<RegistrarProductoPage> createState() =>
      _RegistrarProductoPageState();
}

class _RegistrarProductoPageState
    extends State<RegistrarProductoPage> {
  final TextEditingController _nombreCtrl =
  TextEditingController();
  final TextEditingController _costoCtrl =
  TextEditingController();
  final TextEditingController _precioCtrl =
  TextEditingController();
  final TextEditingController _cantidadCtrl =
  TextEditingController();

  Future<void> agregarProducto() async {
    await ProductoService.agregarProducto(
      nombre: _nombreCtrl.text,
      costo: double.parse(_costoCtrl.text),
      precio: double.parse(_precioCtrl.text),
      cantidad: int.parse(_cantidadCtrl.text),
    );

    _nombreCtrl.clear();
    _costoCtrl.clear();
    _precioCtrl.clear();
    _cantidadCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
      AppBar(title: const Text('Registrar Producto')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nombreCtrl,
              decoration: const InputDecoration(
                  labelText: 'Nombre del producto'),
            ),
            TextField(
              controller: _costoCtrl,
              decoration:
              const InputDecoration(labelText: 'Costo'),
            ),
            TextField(
              controller: _precioCtrl,
              decoration: const InputDecoration(
                  labelText: 'precio de venta'),
            ),
            TextField(
              controller: _cantidadCtrl,
              decoration: const InputDecoration(
                  labelText: 'cantidad'),
            ),
            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: agregarProducto,
              style: ButtonStyle(
                backgroundColor:
                MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    if (states
                        .contains(MaterialState.pressed)) {
                      return Colors.blue
                          .shade700; // Color cuando se presiona
                    }
                    return Colors.blue; // Color normal
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
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                elevation:
                MaterialStateProperty.resolveWith<double>(
                      (Set<MaterialState> states) {
                    if (states
                        .contains(MaterialState.pressed)) {
                      return 12; // Elevación cuando se presiona
                    }
                    return 6; // Elevación normal
                  },
                ),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(20),
                  ),
                ),
              ),
              child: const Text('Agregar Producto'),
            ),

            const Divider(),

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: ProductoService.obtenerProductos(),
                builder: (context, snapshot) {
                  return const SizedBox.shrink(); // no UI, no loader
                },
              ),
            ),

            /*Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: ProductoService.obtenerProductos(),
                //stream: FirebaseFirestore.instance
                    //.collection('productos')
                    //.snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }

                  //var docs = snapshot.data!.docs;

                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                    ),
                  );
                },
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}
