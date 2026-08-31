import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VentaService {

  static String get _uid =>
      FirebaseAuth.instance.currentUser!.uid;

  static FirebaseFirestore get _db =>
      FirebaseFirestore.instance;

  // =============================
  // REGISTRAR VENTA
  // =============================
  static Future<void> registrarVenta({
    required Map<String, Map<String, dynamic>> productos,
    required double total,
    required String metodoPago,
  }) async {

    final ventaRef = await _db
        .collection('usuarios')
        .doc(_uid)
        .collection('ventas')
        .add({
      'total': total,
      'metodo_pago': metodoPago,
      'fecha': Timestamp.now(),
      'cantidad_productos': productos.length,
    });

    for (var entry in productos.entries) {
      final productoId = entry.key;
      final data = entry.value;

      final productoRef = _db
          .collection('usuarios')
          .doc(_uid)
          .collection('productos')
          .doc(productoId);

      await _db.runTransaction((transaction) async {
        final snap = await transaction.get(productoRef);

        if (!snap.exists) {
          throw Exception('Producto no existe');
        }

        final stockActual = snap['cantidad'];

        if (stockActual < data['cantidad']) {
          throw Exception('Stock insuficiente');
        }

        transaction.update(productoRef, {
          'cantidad': stockActual - data['cantidad'],
        });

        transaction.set(
          ventaRef.collection('detalle').doc(),
          {
            'producto_id': productoId,
            'nombre': data['nombre'],
            'precio': data['precio'],
            'cantidad': data['cantidad'],
            'subtotal': data['precio'] * data['cantidad'],
          },
        );
      });
    }
  }

  // =============================
  // STREAM DE VENTAS (REPORTES)
  // =============================
  static Stream<QuerySnapshot> ventasStream({
    required DateTime inicio,
    required DateTime fin,
    required String metodoPago,
  }) {
    Query query = _db
        .collection('usuarios')
        .doc(_uid)
        .collection('ventas')
        .where(
      'fecha',
      isGreaterThanOrEqualTo: Timestamp.fromDate(inicio),
    )
        .where(
      'fecha',
      isLessThan: Timestamp.fromDate(fin),
    );

    if (metodoPago != 'Todos') {
      query = query.where('metodo_pago', isEqualTo: metodoPago);
    }

    return query.orderBy('fecha', descending: true).snapshots();
  }

  // =============================
  // OBTENER VENTAS PARA EXPORTAR
  // =============================
  static Future<List<QueryDocumentSnapshot>> obtenerVentas({
    required DateTime inicio,
    required DateTime fin,
    required String metodoPago,
  }) async {
    Query query = _db
        .collection('usuarios')
        .doc(_uid)
        .collection('ventas')
        .where(
      'fecha',
      isGreaterThanOrEqualTo: Timestamp.fromDate(inicio),
    )
        .where(
      'fecha',
      isLessThan: Timestamp.fromDate(fin),
    );

    if (metodoPago != 'Todos') {
      query = query.where('metodo_pago', isEqualTo: metodoPago);
    }

    final snapshot = await query.orderBy('fecha', descending: true).get();
    return snapshot.docs;
  }

  static Future<List<Map<String, dynamic>>> obtenerVentasConDetalle({
    required DateTime inicio,
    required DateTime fin,
    required String metodoPago,
  }) async {

    Query query = _db
        .collection('usuarios')
        .doc(_uid)
        .collection('ventas')
        .where(
      'fecha',
      isGreaterThanOrEqualTo: Timestamp.fromDate(inicio),
    )
        .where(
      'fecha',
      isLessThan: Timestamp.fromDate(fin),
    );

    if (metodoPago != 'Todos') {
      query = query.where('metodo_pago', isEqualTo: metodoPago);
    }

    final ventasSnap = await query.orderBy('fecha').get();

    List<Map<String, dynamic>> resultado = [];

    for (final ventaDoc in ventasSnap.docs) {
      final ventaData = ventaDoc.data() as Map<String, dynamic>;

      final detalleSnap = await ventaDoc.reference
          .collection('detalle')
          .get();

      final productos = detalleSnap.docs.map((d) {
        return d.data();
      }).toList();

      resultado.add({
        'venta': ventaData,
        'productos': productos,
      });
    }

    return resultado;
  }
}

