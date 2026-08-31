import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProductoService {

  // =============================
  // Referencia dinámica por UID
  // =============================
  static CollectionReference get _productosRef {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('usuarios')
        .doc(uid)
        .collection('productos');
  }

  // =============================
  // Obtener productos (stream)
  // =============================
  static Stream<QuerySnapshot> obtenerProductos() {
    return _productosRef.orderBy('nombre').snapshots();
  }

  // =============================
  // Agregar producto
  // =============================
  static Future<void> agregarProducto({
    required String nombre,
    required double costo,
    required double precio,
    required int cantidad,
  }) async {
    await _productosRef.add({
      'nombre': nombre,
      'costo': costo,
      'precio': precio,
      'cantidad': cantidad,
      'fecha_creacion': Timestamp.now(),
    });
  }

  // =============================
  // Actualizar producto
  // =============================
  static Future<void> actualizarProducto({
    required String id,
    required String nombre,
    required double costo,
    required double precio,
    required int cantidad,
  }) async {
    await _productosRef.doc(id).update({
      'nombre': nombre,
      'costo': costo,
      'precio': precio,
      'cantidad': cantidad,
      'fecha_actualizacion': Timestamp.now(),
    });
  }

  // =============================
  // Eliminar producto
  // =============================
  static Future<void> eliminarProducto(String id) async {
    await _productosRef.doc(id).delete();
  }

  // =============================
  // Obtener productos (una sola vez)
  // =============================
  static Future<QuerySnapshot> obtenerProductosOnce() {
    return _productosRef.orderBy('nombre').get();
  }

}
