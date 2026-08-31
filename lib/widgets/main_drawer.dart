import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../screens/welcome_screen.dart';
import '../screens/perfil_page.dart';
import '../screens/registrar_producto_page.dart';
import '../screens/registrar_compra_page.dart';
import '../screens/registrar_set_page.dart';
import '../screens/inventario_productos_page.dart';
import '../screens/usuarios_page.dart';
import '../dialogs/reportes_dialog.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF90A4AE),
      child: Column(
        children: [
          DrawerHeader(
            child: Padding(
              padding: const EdgeInsets.only(left: 0, top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  const Text(
                    'Menu Principal',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('usuarios')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Text(
                          'Cargando...',
                          style: TextStyle(color: Colors.white70),
                        );
                      }

                      final data = snapshot.data!.data() as Map<String, dynamic>;
                      final nombreUsuario =
                          data['nombre_usuario'] ?? 'usuario';

                      return Text(
                        '@$nombreUsuario',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 20,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          //------ Boton Perfil ------//
          Padding(
            padding: const EdgeInsets.only(left: 30, top: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: 250,
                height: 40,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PerfilPage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.person),
                  label: const Text("Perfil"),
                ),
              ),
            ),
          ),
          //------------------------//

          //------ Boton Registra Producto ------//
          Padding(
            padding: const EdgeInsets.only(left: 30, top: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: 250,
                height: 40,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RegistrarProductoPage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.inventory),
                  label: const Text("Registrar producto"),
                ),
              ),
            ),
          ),
          //---------------------------------------//

          //------ Boton Registra Nueva Compra ------//
          Padding(
            padding: const EdgeInsets.only(left: 30, top: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: 250,
                height: 40,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RegistrarCompraPage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.note_add),
                  label: const Text("Registrar Nueva Compra"),
                ),
              ),
            ),
          ),
          //---------------------------------------//

          //------ Boton Registra Nueva SET ------//
          Padding(
            padding: const EdgeInsets.only(left: 30, top: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: 250,
                height: 40,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RegistrarSETPage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add_box),
                  label: const Text("Registrar Nueva SET"),
                ),
              ),
            ),
          ),
          //---------------------------------------//

          //------ Boton Inventario ------//
          Padding(
            padding: const EdgeInsets.only(left: 30, top: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: 250,
                height: 40,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => InventarioProductosPage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.inventory_2),
                  label: const Text("Inventario"),
                ),
              ),
            ),
          ),
          //---------------------------------------//

          //------ Boton Usuarios ------//
          Padding(
            padding: const EdgeInsets.only(left: 30, top: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: 250,
                height: 40,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => UsuariosPage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.inventory_2),
                  label: const Text("Usuarios"),
                ),
              ),
            ),
          ),
          //---------------------------------------//

          //------ Boton Reporte ------//
          Padding(
            padding: const EdgeInsets.only(left: 30, top: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: 250,
                height: 40,
                child: ElevatedButton.icon(
                  onPressed: () {
                    mostrarReporteDialog(context);
                  },
                  icon: const Icon(Icons.description),
                  label: const Text("Reportes"),
                ),
              ),
            ),
          ),
          //---------------------------------------//

          const Spacer(),

          //------ Cerrar sesión ------//
          Padding(
            padding: const EdgeInsets.only(left: 30, bottom: 30),
            child: Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: 250,
                height: 40,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    //Cerrar sesión en Firebase
                    await FirebaseAuth.instance.signOut();

                    //Regresar a Welcome y borrar historial
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const WelcomeScreen(),
                      ),
                          (route) => false,
                    );
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text("Cerrar sesión"),
                ),
              ),
            ),
          ),
          //-----------------------------//
        ],
      ),
    );
  }
}
