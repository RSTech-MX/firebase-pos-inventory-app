import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/perfil_provider.dart';

class EditarPerfilPage extends StatefulWidget {
  const EditarPerfilPage({super.key});

  @override
  State<EditarPerfilPage> createState() => _EditarPerfilPageState();
}

class _EditarPerfilPageState extends State<EditarPerfilPage> {
  final _nombreCtrl = TextEditingController();
  final _usuarioCtrl = TextEditingController();
  final _edadCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Carga inicial usando addPostFrameCallback para evitar conflictos de renderizado
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = context.read<PerfilProvider>();
      await provider.cargarDatos();

      // Poblamos los controladores de texto con los datos recibidos
      _nombreCtrl.text = provider.datosPerfil['nombre'] ?? '';
      _usuarioCtrl.text = provider.datosPerfil['nombre_usuario'] ?? '';
      _edadCtrl.text = (provider.datosPerfil['edad'] ?? '').toString();
    });
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _usuarioCtrl.dispose();
    _edadCtrl.dispose();
    super.dispose();
  }

  void _ejecutarGuardado() async {
    final provider = context.read<PerfilProvider>();
    final exito = await provider.guardarCambios(
      nombre: _nombreCtrl.text,
      usuario: _usuarioCtrl.text,
      edadText: _edadCtrl.text,
    );

    if (!mounted) return;

    if (exito) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Perfil actualizado')));
      Navigator.pop(context);
    } else if (provider.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${provider.errorMessage}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar perfil')),
      body: Consumer<PerfilProvider>(
        builder: (context, provider, child) {
          if (provider.cargando) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _nombreCtrl,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                ),
                TextField(
                  controller: _usuarioCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Nombre de usuario',
                  ),
                ),
                TextField(
                  controller: _edadCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Edad'),
                ),
                const SizedBox(height: 20),
                provider.guardando
                    ? const CircularProgressIndicator()
                    : ElevatedButton.icon(
                        onPressed: _ejecutarGuardado,
                        icon: const Icon(Icons.save),
                        label: const Text('Guardar cambios'),
                      ),
              ],
            ),
          );
        },
      ),
    );
  }
}
