import 'package:cloud_firestore/cloud_firestore.dart';

class PerfilService {
  static Future<Map<String, dynamic>> obtenerPerfil(String uid) async {
    final doc = await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(uid)
        .get();

    return doc.data()!;
  }

  static Future<void> actualizarPerfil({
    required String uid,
    required String nombre,
    required String usuario,
    required int edad,
  }) async {
    await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(uid)
        .update({
      'nombre': nombre.trim(),
      'nombre_usuario': usuario.trim(),
      'edad': edad,
    });
  }
}
