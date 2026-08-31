import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'dart:io';
import '../services/producto_service.dart';

enum FiltroFecha { dia, mes, anio }

class ReporteProductosPage extends StatefulWidget {
  const ReporteProductosPage({super.key});

  @override
  State<ReporteProductosPage> createState() => _ReporteProductosPageState();
}

class _ReporteProductosPageState extends State<ReporteProductosPage> {

  String get _uid => FirebaseAuth.instance.currentUser!.uid;

  // ---------- STREAM DE PRODUCTOS ----------
  Stream<QuerySnapshot> _productosStream() {
    return ProductoService.obtenerProductos();
  }

  Future<void> _exportarPDF() async {
    // OBTENER PRODUCTOS
    final snapshot = await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('productos')
        .orderBy('nombre')
        .get();

    if (snapshot.docs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay productos para exportar')),
      );
      return;
    }

    final pdf = pw.Document();
    double valorTotalInventario = 0;

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [

              // ===== TITULO =====
              pw.Text(
                'Reporte de Productos',
                style: pw.TextStyle(
                  fontSize: 22,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),

              pw.SizedBox(height: 10),
              pw.Text('Inventario actual'),
              pw.Divider(),

              // ===== TABLA =====
              pw.Table.fromTextArray(
                headers: const [
                  'Producto',
                  'Costo',
                  'Precio',
                  'Stock',
                  'Valor',
                ],
                data: snapshot.docs.map((doc) {
                  final data = doc.data();

                  final nombre = data['nombre'];
                  final costo = (data['costo'] ?? 0).toDouble();
                  final precio = (data['precio'] ?? 0).toDouble();
                  final cantidad = (data['cantidad'] ?? 0) as int;

                  final valor = costo * cantidad;
                  valorTotalInventario += valor;

                  return [
                    nombre,
                    '\$${costo.toStringAsFixed(2)}',
                    '\$${precio.toStringAsFixed(2)}',
                    cantidad.toString(),
                    '\$${valor.toStringAsFixed(2)}',
                  ];
                }).toList(),
              ),

              pw.Divider(),

              // ===== TOTAL INVENTARIO =====
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  'VALOR TOTAL INVENTARIO: \$${valorTotalInventario.toStringAsFixed(2)}',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }

  Future<void> _exportarExcel() async {

    // ===== OBTENER PRODUCTOS =====
    final snapshot = await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('productos')
        .orderBy('nombre')
        .get();

    if (snapshot.docs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay productos para exportar')),
      );
      return;
    }

    final excel = Excel.createExcel();
    excel.rename('Sheet1', 'Inventario');
    final Sheet sheet = excel['Inventario'];

    // ===== ESTILOS =====
    final headerStyle = CellStyle(
      bold: true,
      horizontalAlign: HorizontalAlign.Center,
    );

    // ===== TITULO =====
    sheet.merge(
      CellIndex.indexByString("A1"),
      CellIndex.indexByString("E1"),
    );
    sheet.cell(CellIndex.indexByString("A1")).value =
        TextCellValue("Reporte de Productos");
    sheet.cell(CellIndex.indexByString("A1")).cellStyle =
        CellStyle(bold: true);

    // ===== CABECERAS =====
    final headers = [
      'Producto',
      'Costo',
      'Precio',
      'Stock',
      'Valor',
    ];

    for (int i = 0; i < headers.length; i++) {
      final cell = sheet.cell(
        CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 3),
      );
      cell.value = TextCellValue(headers[i]);
      cell.cellStyle = headerStyle;
    }

    // ===== DATOS =====
    int row = 4;
    double valorTotalInventario = 0;

    for (final doc in snapshot.docs) {
      final data = doc.data();

      final nombre = data['nombre'];
      final costo = (data['costo'] ?? 0).toDouble();
      final precio = (data['precio'] ?? 0).toDouble();
      final cantidad = (data['cantidad'] ?? 0) as int;

      final valor = costo * cantidad;
      valorTotalInventario += valor;

      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row))
          .value = TextCellValue(nombre);

      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row))
          .value = DoubleCellValue(costo);

      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row))
          .value = DoubleCellValue(precio);

      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row))
          .value = IntCellValue(cantidad);

      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: row))
          .value = DoubleCellValue(valor);

      row++;
    }

    // ===== TOTAL INVENTARIO =====
    row++;
    sheet.merge(
      CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row),
      CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row),
    );

    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row))
        .value = TextCellValue("VALOR TOTAL INVENTARIO");
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row))
        .cellStyle = CellStyle(bold: true);

    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: row))
        .value = DoubleCellValue(valorTotalInventario);
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: row))
        .cellStyle = CellStyle(bold: true);

    // ===== GUARDAR ARCHIVO =====
    final directory = await getApplicationDocumentsDirectory();
    final filePath =
        "${directory.path}/reporte_productos_${DateTime.now().millisecondsSinceEpoch}.xlsx";

    final file = File(filePath);
    file.writeAsBytesSync(excel.encode()!);

    // ===== ABRIR EXCEL =====
    await OpenFilex.open(filePath);
  }


  //List<QueryDocumentSnapshot> _ventasActuales = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reporte de Productos'),
        backgroundColor: Colors.green,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ================= FILTROS =================
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  // ---------- EXPORTAR PDF ----------
                  ElevatedButton.icon(
                    icon: const Icon(Icons.picture_as_pdf),
                    label: const Text('Exportar PDF'),
                    onPressed:
                    _exportarPDF,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),

                  ElevatedButton.icon(
                    icon: const Icon(Icons.table_chart),
                    label: const Text('Exportar Excel'),
                    onPressed:
                    _exportarExcel,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),

                ],
              ),
            ),

            const Divider(),

            // ================= LISTA =================
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: ProductoService.obtenerProductos(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text('No hay productos registrados'),
                    );
                  }

                  final productos = snapshot.data!.docs;

                  return ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: productos.length,
                    itemBuilder: (_, index) {
                      final data =
                      productos[index].data() as Map<String, dynamic>;

                      final nombre = data['nombre'];
                      final costo = (data['costo'] ?? 0).toDouble();
                      final precio = (data['precio'] ?? 0).toDouble();
                      final cantidad = (data['cantidad'] ?? 0) as int;

                      final valorInventario = costo * cantidad;

                      return Card(
                        elevation: 4,
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              // ===== NOMBRE =====
                              Text(
                                nombre,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),

                              const SizedBox(height: 6),

                              // ===== INFO =====
                              Text('Costo: \$${costo.toStringAsFixed(2)}'),
                              Text('Precio: \$${precio.toStringAsFixed(2)}'),
                              Text('Stock: $cantidad'),

                              const Divider(),

                              // ===== VALOR =====
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  'Valor inventario: \$${valorInventario.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
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
          ],
        ),
      ),
    );
  }
}