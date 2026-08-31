import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/set_service.dart';

class RegistrarSETPage extends StatefulWidget {
  const RegistrarSETPage({super.key});

  @override
  State<RegistrarSETPage> createState() =>
      _RegistrarSETPageState();
}

class _RegistrarSETPageState
    extends State<RegistrarSETPage> {

  File? imagenTomada;
  final picker = ImagePicker();
  final nombreController = TextEditingController();
  final localizacionController = TextEditingController();
  final ubicacionController = TextEditingController();

  // =============================
  // 1. Tomar Foto
  // =============================
  Future<void> tomarFoto() async {
    final XFile? foto =
    await picker.pickImage(source: ImageSource.camera);
    if (foto != null) {
      setState(() {
        imagenTomada = File(foto.path);
      });
    }
  }

  // =============================
  // 2. Subir Imagen a Storage
  // =============================
  /*Future<String> subirImagen(File imagen) async {
    final nombreArchivo =
        "productos/${DateTime.now().millisecondsSinceEpoch}.jpg";

    final ref = FirebaseStorage.instance.ref().child(nombreArchivo);
    final upload = await ref.putFile(imagen);

    return await upload.ref.getDownloadURL();
  }*/

  // =============================
  // 3. Guardar en Firestore
  // =============================
  Future<void> subirProducto() async {
    /*if (imagenTomada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Primero toma una foto")),
      );
      return;
    }*/

    await SetService.guardarSet(
      nombreSet: nombreController.text,
      localizacion: localizacionController.text,
      ubicacion: ubicacionController.text,
    );

    nombreController.clear();
    localizacionController.clear();
    ubicacionController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("SET registrado con éxito")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registrar SET"),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [

            // Mostrar imagen tomada
            imagenTomada != null
                ? Image.file(imagenTomada!, height: 200)
                : Container(
              height: 200,
              color: Colors.grey[300],
              child:
              Center(child: Text("No hay imagen")),
            ),

            SizedBox(height: 10),

            ElevatedButton(
              onPressed: tomarFoto,
              child: Text("Tomar Foto"),
            ),

            SizedBox(height: 20),

            TextField(
              controller: nombreController,
              decoration:
              InputDecoration(labelText: "Nombre de SET"),
            ),

            TextField(
              controller: localizacionController,
              decoration: InputDecoration(
                  labelText: "Localizacion del SET"),
            ),

            TextField(
              controller: ubicacionController,
              decoration:
              InputDecoration(labelText: "Ubicacion"),
            ),

            SizedBox(height: 30),

            ElevatedButton(
              onPressed: subirProducto,
              child: Text("Registrar SET"),
            ),

          ],
        ),
      ),
    );
  }
}