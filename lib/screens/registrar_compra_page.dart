import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

import '../services/compra_service.dart';

class RegistrarCompraPage extends StatefulWidget {
  const RegistrarCompraPage({super.key});

  @override
  State<RegistrarCompraPage> createState() =>
      _RegistrarCompraPageState();
}

class _RegistrarCompraPageState
    extends State<RegistrarCompraPage> {

  File? imagenTomada;
  final picker = ImagePicker();

  final fechaCompraController =
  MaskedTextController(mask: '00/00/0000');
  final descripcionController = TextEditingController();
  final rfcprovedorController = TextEditingController();
  final provedorController = TextEditingController();
  final costoController = TextEditingController();
  final tipoPagoController = TextEditingController();
  final tipoTarjetaController = TextEditingController();
  final ticketController = TextEditingController();
  final fechaFacturaController =
  MaskedTextController(mask: '00/00/0000');
  final folioFiscalController = TextEditingController();
  final setController = TextEditingController();

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

    await CompraService.guardarCompra(
      fechacompra: fechaCompraController.text,
      descripcion: descripcionController.text,
      rfcprovedor: rfcprovedorController.text,
      provedor: provedorController.text,
      costo: double.parse(costoController.text),
      tipopago: tipoPagoController.text,
      tipotarjeta: tipoTarjetaController.text,
      ticket: ticketController.text,
      fechafactura: fechaFacturaController.text,
      foliofiscal: folioFiscalController.text,
      set: setController.text,
    );

    fechaCompraController.clear();
    descripcionController.clear();
    rfcprovedorController.clear();
    provedorController.clear();
    costoController.clear();
    tipoPagoController.clear();
    tipoTarjetaController.clear();
    ticketController.clear();
    fechaFacturaController.clear();
    folioFiscalController.clear();
    setController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Producto registrado con éxito")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registrar Compra"),
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
              controller: fechaCompraController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText:
                "Fecha de compra (dd/mm/aaaa)",
              ),
            ),

            TextField(
              controller: descripcionController,
              decoration:
              InputDecoration(labelText: "Descripcion"),
            ),

            TextField(
              controller: rfcprovedorController,
              decoration: InputDecoration(
                  labelText: "RFC del Provedor"),
            ),

            TextField(
              controller: provedorController,
              decoration:
              InputDecoration(labelText: "Provedor"),
            ),

            TextField(
              controller: costoController,
              decoration:
              InputDecoration(labelText: "Costo"),
              keyboardType: TextInputType.number,
            ),

            // --- TextField PRINCIPAL ---
            TextField(
              controller: tipoPagoController,
              readOnly: true,
              decoration:
              InputDecoration(labelText: "Tipo de pago"),
              onTap: () {
                _mostrarOpcionesPago(context);
              },
            ),

            // --- SI ES TARJETA, MOSTRAR ESTE FIELD ---
            if (tipoPagoController.text == "Tarjeta")
              TextField(
                controller: tipoTarjetaController,
                readOnly: true,
                decoration: InputDecoration(
                    labelText: "Tipo de tarjeta"),
                onTap: () {
                  _mostrarOpcionesTarjeta(context);
                },
              ),

            TextField(
              controller: ticketController,
              decoration:
              InputDecoration(labelText: "Ticket"),
            ),

            TextField(
              controller: fechaFacturaController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText:
                "Fecha de la factura (dd/mm/aaaa)",
              ),
            ),

            TextField(
              controller: folioFiscalController,
              decoration:
              InputDecoration(labelText: "Folio Fiscal"),
            ),

            TextField(
              controller: setController,
              decoration:
              InputDecoration(labelText: "Set"),
            ),

            SizedBox(height: 30),

            ElevatedButton(
              onPressed: subirProducto,
              child: Text("Subir compra"),
            ),

            SizedBox(height: 10),

            /*ElevatedButton(
              onPressed: () =>
                  CompraService.generarReporte(),
              child: Text("Reporte"),
            ),*/
          ],
        ),
      ),
    );
  }

  void _mostrarOpcionesPago(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text("Efectivo"),
              onTap: () {
                setState(() {
                  tipoPagoController.text = "Efectivo";
                  tipoTarjetaController.clear();
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("Transferencia"),
              onTap: () {
                setState(() {
                  tipoPagoController.text =
                  "Transferencia";
                  tipoTarjetaController.clear();
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("Tarjeta"),
              onTap: () {
                setState(() {
                  tipoPagoController.text = "Tarjeta";
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _mostrarOpcionesTarjeta(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text("Crédito"),
              onTap: () {
                setState(() {
                  tipoTarjetaController.text = "Crédito";
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("Débito"),
              onTap: () {
                setState(() {
                  tipoTarjetaController.text = "Débito";
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
