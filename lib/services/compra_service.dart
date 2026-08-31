import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:excel/excel.dart';
//import 'package:path_provider/path_provider.dart';
//import 'package:open_filex/open_filex.dart';

class CompraService {

  // =============================
  // 3. Guardar en Firestore
  // =============================
  static Future<void> guardarCompra({
    required String fechacompra,
    required String descripcion,
    required String rfcprovedor,
    required String provedor,
    required double costo,
    required String tipopago,
    required String tipotarjeta,
    required String ticket,
    required String fechafactura,
    required String foliofiscal,
    required String set,
    // required String imagenUrl,
  }) async {

    final uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(uid)
        .collection('compras')
        .add({
      "fecha de compra": fechacompra,
      "descripcion": descripcion,
      "rfc provedor": rfcprovedor,
      "provedor": provedor,
      "costo": costo,
      "tipo de pago": tipopago,
      "tipo de tarjeta": tipotarjeta,
      "ticket": ticket,
      "fecha de factura": fechafactura,
      "folio fiscal": foliofiscal,
      "set": set,
      //"imagen": imagenUrl,
      "fecha": DateTime.now(),
    });
  }

  // =============================
  // Reporte Excel
  // =============================
  /*static Future<void> generarReporte() async {
    try {
      // 1. Obtener datos de Firestore
      final querySnapshot = await FirebaseFirestore.instance
          .collection("compras")
          .orderBy("fecha", descending: false)
          .get();

      // 2. Crear archivo Excel
      var excel = Excel.createExcel();
      Sheet sheet = excel['Compras'];

      // 3. Escribir encabezados
      sheet.appendRow([
        "Fecha de compra",
        "Descripción",
        "RFC proveedor",
        "Proveedor",
        "Costo",
        "Tipo de pago",
        "Tipo de tarjeta",
        "Ticket",
        "Fecha de factura",
        "Folio fiscal",
        "Set",
        "Fecha registro"
      ]);

      // 4. Llenar filas con los documentos
      for (var doc in querySnapshot.docs) {
        var data = doc.data();

        sheet.appendRow([
          data["fecha de compra"] ?? "",
          data["descripcion"] ?? "",
          data["rfc provedor"] ?? "",
          data["provedor"] ?? "",
          data["costo"] ?? "",
          data["tipo de pago"] ?? "",
          data["tipo de tarjeta"] ?? "",
          data["ticket"] ?? "",
          data["fecha de factura"] ?? "",
          data["folio fiscal"] ?? "",
          data["set"] ?? "",
          data["fecha"] != null ? data["fecha"].toDate().toString() : "",
        ]);
      }

      // 5. Convertir a bytes
      final excelBytes = excel.encode();

      // 6. Guardar archivo en almacenamiento local
      final dir = await getApplicationDocumentsDirectory();
      final file = File("${dir.path}/Reporte_Compras.xlsx");

      await file.writeAsBytes(excelBytes!);

      // 7. Abrir el archivo
      await OpenFilex.open(file.path);

      print("Reporte generado en: ${file.path}");
    } catch (e) {
      print("Error al generar reporte: $e");
    }
  }*/
}
