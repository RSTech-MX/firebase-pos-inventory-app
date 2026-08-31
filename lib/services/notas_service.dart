import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotasService {

  // =============================
  // Referencia dinámica por UID
  // =============================
  static CollectionReference get _notasRef {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('usuarios')
        .doc(uid)
        .collection('notas');
  }

  // =============================
  // Obtener notas (stream)
  // =============================
  static Stream<QuerySnapshot> obtenerNota() {
    return _notasRef.orderBy('titulo').snapshots();
  }

  // =============================
  // Agregar nota
  // =============================
  static Future<void> agregarNota({
    required String titulo,
    required String contenido,
    required int color,
  }) async {
    await _notasRef.add({
      'titulo': titulo,
      'contenido': contenido,
      'color': color,
      'fecha_creacion': Timestamp.now(),
    });
  }

  // =============================
  // Actualizar nota
  // =============================
  static Future<void> actualizarNota({
    required String id,
    required String titulo,
    required String contenido,
    required int color,
  }) async {
    await _notasRef.doc(id).update({
      'titulo': titulo,
      'contenido': contenido,
      'color': color,
      'fecha_actualizacion': Timestamp.now(),
    });
  }

  // =============================
  // Eliminar nota
  // =============================
  static Future<void> eliminarNota(String id) async {
    await _notasRef.doc(id).delete();
  }
}