import '../screens/notas_page.dart';
import 'package:flutter/material.dart';
import '../widgets/main_drawer.dart';
import '../screens/ventas_page.dart';
import '../services/notas_service.dart';
import '../dialogs/nueva_nota_dialog.dart';
import '../dialogs/editar_producto_dialog.dart';
import '../dialogs/calculadora_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void mostrarCalculadora() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const CalculadoraDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text(
          'App de administracio',
          style: TextStyle(color: Colors.white),
        ),
      ),

      // Menu Principal
      drawer: const MainDrawer(),

      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Padding(
              padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ================= BOTONES =================
                  Row(
                    children: [
                      SizedBox(
                        width: 153,
                        height: 40,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const VentasPage(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.attach_money),
                          label: const Text("Venta"),
                        ),
                      ),

                      const SizedBox(width: 12),

                      SizedBox(
                        width: 153,
                        height: 40,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () =>
                              mostrarDialogAgregarProducto(context),
                          icon: const Icon(Icons.shopping_cart),
                          label: const Text("Compra"),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      SizedBox(
                        width: 153,
                        height: 40,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.yellow,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const NotasPage(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.notes),
                          label: const Text("Notas"),
                        ),
                      ),

                      const SizedBox(width: 12),

                      SizedBox(
                        width: 153,
                        height: 40,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: mostrarCalculadora,
                          icon: const Icon(Icons.calculate),
                          label: const Text("Calculadora"),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ================= LISTA DE NOTAS =================
                  Expanded(
                    child: StreamBuilder(
                      stream: NotasService.obtenerNota(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Center(child: Text("No hay notas aún"));
                        }

                        final notas = snapshot.data!.docs;

                        return ListView.builder(
                          itemCount: notas.length,
                          itemBuilder: (context, index) {
                            final doc = notas[index];
                            final data = doc.data() as Map<String, dynamic>;

                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Color(
                                  data['color'] ?? Colors.yellow.value,
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: const Offset(2, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data['titulo'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(data['contenido']),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        NotasService.eliminarNota(doc.id);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => mostrarDialogAgregarNota(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
