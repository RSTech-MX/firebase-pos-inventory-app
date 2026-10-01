import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/correo_provider.dart';

class CambiarCorreoPage extends StatefulWidget {
  const CambiarCorreoPage({super.key});

  @override
  State<CambiarCorreoPage> createState() => _CambiarCorreoPageState();
}

class _CambiarCorreoPageState extends State<CambiarCorreoPage> {
  final _nuevoCorreoCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  void dispose() {
    _nuevoCorreoCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _ejecutarCambio() async {
    final provider = context.read<CorreoProvider>();
    final exito = await provider.cambiarCorreo(
      nuevoCorreo: _nuevoCorreoCtrl.text,
      password: _passwordCtrl.text,
    );

    if (!mounted) return;

    if (exito) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Correo actualizado correctamente')),
      );
      Navigator.pop(context);
    } else if (provider.errorMessage != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(provider.errorMessage!)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cambiar correo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nuevoCorreoCtrl,
              decoration: const InputDecoration(labelText: 'Nuevo correo'),
            ),
            TextField(
              controller: _passwordCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Contraseña actual'),
            ),
            const SizedBox(height: 20),

            // Solo esta sección reacciona a los cambios de estado de carga
            Consumer<CorreoProvider>(
              builder: (context, provider, child) {
                return provider.cargando
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _ejecutarCambio,
                        child: const Text('Guardar cambios'),
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}
