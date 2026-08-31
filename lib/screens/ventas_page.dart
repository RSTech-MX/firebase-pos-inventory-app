import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/producto_service.dart';
import '../services/venta_service.dart';

class VentasPage extends StatefulWidget {
  const VentasPage({super.key});

  @override
  State<VentasPage> createState() => _VentasPageState();
}

class _VentasPageState extends State<VentasPage> {

  // carrito[productoId] = { nombre, precio, cantidad }
  final Map<String, Map<String, dynamic>> carrito = {};
  String metodoPago = '';

  double total = 0;

  // =============================
  // Agregar producto al carrito
  // =============================
  void agregarAlCarrito(
      String id,
      String nombre,
      double precio,
      ) {
    setState(() {
      if (carrito.containsKey(id)) {
        carrito[id]!['cantidad']++;
      } else {
        carrito[id] = {
          'nombre': nombre,
          'precio': precio,
          'cantidad': 1,
        };
      }

      total += precio;
    });
  }

  // =============================
  // Eliminar producto del carrito
  // =============================
  void eliminarDelCarrito(
      String id,
      double precio,
      ) {
    setState(() {
      if (!carrito.containsKey(id)) return;

      carrito[id]!['cantidad']--;

      total -= precio;

      if (carrito[id]!['cantidad'] <= 0) {
        carrito.remove(id);
      }
    });
  }

  void mostrarCarrito() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              const SizedBox(height: 25),

              // Título
              const Text(
                'Carrito',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),

              const SizedBox(height: 10),

              // Lista de productos en carrito
              Expanded(
                child: carrito.isEmpty
                    ? const Center(child: Text('Carrito vacío'))
                    : ListView(
                  children: carrito.entries.map((entry) {
                    final item = entry.value;

                    final nombre = item['nombre'];
                    final precio = item['precio'];
                    final cantidad = item['cantidad'];
                    final subtotal = precio * cantidad;

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: ListTile(
                        title: Text(
                          nombre,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          '$cantidad x \$${precio.toStringAsFixed(2)}',
                        ),
                        trailing: Text(
                          '\$${subtotal.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const Divider(),

              // Total
              Text(
                'Total: \$${total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              // Botón cobrar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: carrito.isEmpty
                      ? null
                      : () {
                    Navigator.pop(context);
                    mostrarMetodoPago();
                  },
                  icon: const Icon(Icons.attach_money),
                  label: const Text('Cobrar'),
                ),
              ),

              // Botón regresar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Regresar'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void mostrarMetodoPago() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Método de pago',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              // EFECTIVO
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 45),
                ),
                icon: const Icon(Icons.money),
                label: const Text('Efectivo'),
                onPressed: () async {
                  setState(() {
                    metodoPago = 'efectivo';
                  });
                  Navigator.pop(context);
                  await cobrar();
                },
              ),

              const SizedBox(height: 10),

              // TARJETA
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 45),
                ),
                icon: const Icon(Icons.credit_card),
                label: const Text('Tarjeta'),
                onPressed: () async {
                  setState(() {
                    metodoPago = 'tarjeta';
                  });

                  Navigator.pop(context);
                  await cobrar();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // =============================
  // Cobrar venta
  // =============================
  Future<void> cobrar() async {
    try {
      await VentaService.registrarVenta(
        productos: carrito,
        total: total,
        metodoPago: metodoPago,
      );

      setState(() {
        carrito.clear();
        total = 0;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Venta realizada correctamente'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cobrar: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Punto de Venta'),
        backgroundColor: Colors.green,
      ),

      body: Column(
        children: [

          // =============================
          // LISTA DE PRODUCTOS
          // =============================
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: ProductoService.obtenerProductos(),
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (!snapshot.hasData ||
                    snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('No hay productos'),
                  );
                }

                final productos = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: productos.length,
                  itemBuilder: (context, index) {
                    final doc = productos[index];
                    final data =
                    doc.data() as Map<String, dynamic>;

                    final nombre = data['nombre'];
                    final precio =
                    (data['precio'] as num).toDouble();
                    final stock = data['cantidad'];

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: ListTile(
                        title: Text(nombre),
                        subtitle: Text(
                          'Precio: \$${precio.toStringAsFixed(2)} | Stock: $stock',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.add_circle,
                                color: Colors.green,
                              ),
                              onPressed: stock > 0
                                  ? () => agregarAlCarrito(
                                doc.id,
                                nombre,
                                precio,
                              )
                                  : null,
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.remove_circle,
                                color: Colors.red,
                              ),
                              onPressed: carrito.containsKey(doc.id)
                                  ? () => eliminarDelCarrito(
                                doc.id,
                                precio,
                              )
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // =============================
          // TOTAL Y BOTÓN COBRAR
          // =============================
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                )
              ],
            ),
            child: Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total: \$${total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: carrito.isEmpty ? null : mostrarCarrito,
                  icon: const Icon(Icons.shopping_cart),
                  label: const Text('Ver carrito'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

