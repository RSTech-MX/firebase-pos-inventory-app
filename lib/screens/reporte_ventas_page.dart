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
import '../services/venta_service.dart';

enum FiltroFecha { dia, mes, anio }

class ReporteVentasPage extends StatefulWidget {
  const ReporteVentasPage({super.key});

  @override
  State<ReporteVentasPage> createState() => _ReporteVentasPageState();
}

class _ReporteVentasPageState extends State<ReporteVentasPage> {
  FiltroFecha _filtroFecha = FiltroFecha.dia;
  String _metodoPago = 'Todos';
  DateTime _fechaSeleccionada = DateTime.now();

  String get _uid => FirebaseAuth.instance.currentUser!.uid;

  // ---------- RANGOS DE FECHA ----------
  DateTime _inicioFecha() {
    final f = _fechaSeleccionada;
    switch (_filtroFecha) {
      case FiltroFecha.dia:
        return DateTime(f.year, f.month, f.day);
      case FiltroFecha.mes:
        return DateTime(f.year, f.month);
      case FiltroFecha.anio:
        return DateTime(f.year);
    }
  }

  DateTime _finFecha() {
    final inicio = _inicioFecha();
    switch (_filtroFecha) {
      case FiltroFecha.dia:
        return inicio.add(const Duration(days: 1));
      case FiltroFecha.mes:
        return DateTime(inicio.year, inicio.month + 1);
      case FiltroFecha.anio:
        return DateTime(inicio.year + 1);
    }
  }

  // ---------- STREAM ----------
  Stream<QuerySnapshot> _ventasStream() {
    return VentaService.ventasStream(
      inicio: _inicioFecha(),
      fin: _finFecha(),
      metodoPago: _metodoPago,
    );
  }

  /*Stream<QuerySnapshot> _ventasStream() {
    Query query = FirebaseFirestore.instance
        .collection('usuarios')
        .doc(_uid)
        .collection('ventas')
        .where(
      'fecha',
      isGreaterThanOrEqualTo: Timestamp.fromDate(_inicioFecha()),
    )
        .where(
      'fecha',
      isLessThan: Timestamp.fromDate(_finFecha()),
    );

    if (_metodoPago != 'Todos') {
      query = query.where('metodo_pago', isEqualTo: _metodoPago);
    }

    return query.orderBy('fecha', descending: true).snapshots();
  }*/

  Future<void> _seleccionarDia() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _fechaSeleccionada,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _fechaSeleccionada = picked;
      });
    }
  }

  Future<void> _seleccionarMes() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _fechaSeleccionada,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.year,
    );

    if (picked != null) {
      setState(() {
        _fechaSeleccionada = DateTime(picked.year, picked.month);
      });
    }
  }

  Future<void> _seleccionarAnio() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _fechaSeleccionada,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.year,
    );

    if (picked != null) {
      setState(() {
        _fechaSeleccionada = DateTime(picked.year);
      });
    }
  }

  Future<void> _exportarPDF() async {

    // OBTENER VENTAS DESDE EL SERVICE
    final ventas = await VentaService.obtenerVentasConDetalle(
      inicio: _inicioFecha(),
      fin: _finFecha(),
      metodoPago: _metodoPago,
    );

    if (ventas.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay ventas para exportar')),
      );
      return;
    }

    final pdf = pw.Document();
    double totalGeneral = 0;

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [

              // ===== TITULO =====
              pw.Text(
                'Reporte de Ventas',
                style: pw.TextStyle(
                  fontSize: 22,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),

              pw.SizedBox(height: 8),

              pw.Text('Filtro: ${_filtroFecha.name.toUpperCase()}'),
              pw.Text(
                'Fecha: ${_fechaSeleccionada.toString().substring(0, 10)}',
              ),
              pw.Text('Método de pago: $_metodoPago'),

              pw.Divider(),

              // ===== TABLA CON PRODUCTOS =====
              pw.Table.fromTextArray(
                headers: const [
                  'Fecha',
                  'Método',
                  'Producto',
                  'Precio',
                  'Cantidad',
                  'Subtotal',
                ],
                data: ventas.expand((item) {
                  final venta = item['venta'];
                  final productos = item['productos'] as List;

                  final fecha =
                  (venta['fecha'] as Timestamp).toDate();
                  final metodo = venta['metodo_pago'];

                  totalGeneral += (venta['total'] ?? 0).toDouble();

                  return productos.map((p) {
                    return [
                      fecha.toString().substring(0, 16),
                      metodo,
                      p['nombre'],
                      '\$${(p['precio'] as num).toStringAsFixed(2)}',
                      p['cantidad'].toString(),
                      '\$${(p['subtotal'] as num).toStringAsFixed(2)}',
                    ];
                  });
                }).toList(),
              ),

              pw.Divider(),

              // ===== TOTAL GENERAL =====
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  'TOTAL GENERAL: \$${totalGeneral.toStringAsFixed(2)}',
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

    // ===== OBTENER VENTAS CON DETALLE =====
    final ventas = await VentaService.obtenerVentasConDetalle(
      inicio: _inicioFecha(),
      fin: _finFecha(),
      metodoPago: _metodoPago,
    );

    if (ventas.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay ventas para exportar')),
      );
      return;
    }

    final excel = Excel.createExcel();
    excel.rename('Sheet1', 'Reporte');
    final Sheet sheet = excel['Reporte'];

    // ===== ESTILOS =====
    final headerStyle = CellStyle(
      bold: true,
      horizontalAlign: HorizontalAlign.Center,
    );

    // ===== TITULO =====
    sheet.merge(
      CellIndex.indexByString("A1"),
      CellIndex.indexByString("F1"),
    );
    sheet.cell(CellIndex.indexByString("A1")).value =
        TextCellValue("Reporte de Ventas");
    sheet.cell(CellIndex.indexByString("A1")).cellStyle =
        CellStyle(bold: true);

    // ===== INFO =====
    sheet.cell(CellIndex.indexByString("A3")).value =
        TextCellValue("Filtro:");
    sheet.cell(CellIndex.indexByString("B3")).value =
        TextCellValue(_filtroFecha.name.toUpperCase());

    sheet.cell(CellIndex.indexByString("A4")).value =
        TextCellValue("Fecha:");
    sheet.cell(CellIndex.indexByString("B4")).value =
        TextCellValue(_fechaSeleccionada.toString().substring(0, 10));

    sheet.cell(CellIndex.indexByString("A5")).value =
        TextCellValue("Método de pago:");
    sheet.cell(CellIndex.indexByString("B5")).value =
        TextCellValue(_metodoPago ?? 'Todos');

    // ===== CABECERAS =====
    final headers = [
      'Fecha',
      'Método',
      'Producto',
      'Precio',
      'Cantidad',
      'Subtotal',
    ];

    for (int i = 0; i < headers.length; i++) {
      final cell =
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 6));
      cell.value = TextCellValue(headers[i]);
      cell.cellStyle = headerStyle;
    }

    // ===== DATOS =====
    int row = 7;
    double totalGeneral = 0;

    for (final item in ventas) {
      final venta = item['venta'];
      final productos = item['productos'] as List;

      final fecha =
      (venta['fecha'] as Timestamp).toDate();
      final metodo = venta['metodo_pago'] ?? 'No especificado';
      totalGeneral += (venta['total'] ?? 0).toDouble();

      for (final p in productos) {
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row))
            .value = TextCellValue(fecha.toString().substring(0, 16));

        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row))
            .value = TextCellValue(metodo);

        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row))
            .value = TextCellValue(p['nombre']);

        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row))
            .value =
            DoubleCellValue((p['precio'] as num).toDouble());

        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: row))
            .value =
            IntCellValue((p['cantidad'] as num).toInt());

        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: row))
            .value =
            DoubleCellValue((p['subtotal'] as num).toDouble());

        row++;
      }
    }

    // ===== TOTAL GENERAL =====
    row++;
    sheet.merge(
      CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row),
      CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: row),
    );

    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row))
        .value = TextCellValue("TOTAL GENERAL");

    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row))
        .cellStyle = CellStyle(bold: true);

    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: row))
        .value = DoubleCellValue(totalGeneral);

    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: row))
        .cellStyle = CellStyle(bold: true);

    // ===== GUARDAR ARCHIVO =====
    final directory = await getApplicationDocumentsDirectory();
    final filePath =
        "${directory.path}/reporte_ventas_${DateTime.now().millisecondsSinceEpoch}.xlsx";

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
        title: const Text('Reporte de Ventas'),
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
                  // ----- FECHA -----
                Wrap(
                spacing: 8,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  // -------- TIPO DE FILTRO --------
                  ChoiceChip(
                    label: const Text('Día'),
                    selected: _filtroFecha == FiltroFecha.dia,
                    onSelected: (selected) {
                      if (!selected) return;
                      setState(() {
                        _filtroFecha = FiltroFecha.dia;
                      });
                    },
                  ),

                  ChoiceChip(
                    label: const Text('Mes'),
                    selected: _filtroFecha == FiltroFecha.mes,
                    onSelected: (selected) {
                      if (!selected) return;
                      setState(() {
                        _filtroFecha = FiltroFecha.mes;
                      });
                    },
                  ),

                  ChoiceChip(
                    label: const Text('Año'),
                    selected: _filtroFecha == FiltroFecha.anio,
                    onSelected: (selected) {
                      if (!selected) return;
                      setState(() {
                        _filtroFecha = FiltroFecha.anio;
                      });
                    },
                  ),

                  // -------- SELECCIÓN DE FECHA --------
                  TextButton.icon(
                    icon: const Icon(Icons.calendar_month),
                    label: Text(
                      _filtroFecha == FiltroFecha.dia
                          ? 'Elegir día'
                          : _filtroFecha == FiltroFecha.mes
                          ? 'Elegir mes'
                          : 'Elegir año',
                    ),
                    onPressed: () {
                      if (_filtroFecha == FiltroFecha.dia) {
                        _seleccionarDia();
                      } else if (_filtroFecha == FiltroFecha.mes) {
                        _seleccionarMes();
                      } else {
                        _seleccionarAnio();
                      }
                    },
                  ),
                ],
              ),

                const SizedBox(height: 10),

                  // ----- METODO DE PAGO -----
                  DropdownButton<String>(
                    value: _metodoPago,
                    items: const [
                      DropdownMenuItem(
                        value: 'Todos',
                        child: Text('Todos'),
                      ),
                      DropdownMenuItem(
                        value: 'efectivo',
                        child: Text('Efectivo'),
                      ),
                      DropdownMenuItem(
                        value: 'tarjeta',
                        child: Text('Tarjeta'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() => _metodoPago = value!);
                    },
                  ),

                  const SizedBox(height: 12),

                  // ---------- EXPORTAR PDF ----------
                  ElevatedButton.icon(
                    icon: const Icon(Icons.picture_as_pdf),
                    label: const Text('Exportar PDF'),
                    onPressed:
                    //_ventasActuales.isEmpty ? null :
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
                    //_ventasActuales.isEmpty ? null :
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
                stream: _ventasStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text('No hay ventas registradas'),
                    );
                  }

                  final ventas = snapshot.data!.docs;

                  return ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: ventas.length,
                    itemBuilder: (_, index) {
                      final ventaDoc = ventas[index];
                      final data = ventaDoc.data() as Map<String, dynamic>;

                      final total = (data['total'] ?? 0).toDouble();
                      final metodo = data['metodo_pago'];
                      final fecha = (data['fecha'] as Timestamp).toDate();

                      return Card(
                        elevation: 4,
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              // ===== INFO VENTA =====
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Venta',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium,
                                  ),
                                  Text(
                                    fecha.toString().substring(0, 16),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 4),
                              Text('Método de pago: $metodo'),

                              const Divider(),

                              // ===== PRODUCTOS =====
                              FutureBuilder<QuerySnapshot>(
                                future: ventaDoc.reference
                                    .collection('detalle')
                                    .get(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return const Padding(
                                      padding: EdgeInsets.symmetric(vertical: 8),
                                      child: CircularProgressIndicator(),
                                    );
                                  }

                                  final productos = snapshot.data!.docs;

                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: productos.map((p) {
                                      final prod =
                                      p.data() as Map<String, dynamic>;

                                      return Padding(
                                        padding:
                                        const EdgeInsets.symmetric(vertical: 2),
                                        child: Text(
                                          '• ${prod['nombre']} '
                                              'x${prod['cantidad']}  '
                                              '(\$${prod['precio']})  '
                                              '= \$${prod['subtotal'].toStringAsFixed(2)}',
                                        ),
                                      );
                                    }).toList(),
                                  );
                                },
                              ),

                              const Divider(),

                              // ===== TOTAL =====
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  'Total: \$${total.toStringAsFixed(2)}',
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
