import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UsuarioService {

  // =============================
  // Registro (Auth + Firestore)
  // =============================
  static Future<void> registrarUsuario({
    required String nombre,
    required String nombreUsuario,
    required int edad,
    required String correo,
    required String password,
  }) async {
    UserCredential userCredential =
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: correo.trim(),
      password: password.trim(),
    );

    String uid = userCredential.user!.uid;

    await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(uid)
        .set({
      'uid': uid,
      'nombre': nombre,
      'nombre_usuario': nombreUsuario,
      'edad': edad,
      'correo': correo,
      'rol': 'user',
      'fecha_creacion': Timestamp.now(),
    });
  }

  // =============================
  // Leer el rol del usuario
  static Future<String> obtenerRol(String uid) async {
    final doc = await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(uid)
        .get();

    if (!doc.exists) return 'user';

    return doc['rol'];
  }

  static Future<bool> esMaster(String uid) async {
    final rol = await obtenerRol(uid);
    return rol == 'master';
  }

  static Future<bool> esAdmin(String uid) async {
    final rol = await obtenerRol(uid);
    return rol == 'admin' || rol == 'master';
  }

  static Stream<QuerySnapshot> obtenerUsuariosSegunRol(String uid) async* {
    final rol = await obtenerRol(uid);

    if (rol == 'admin' || rol == 'master') {
      yield* _usuariosRef.orderBy('nombre').snapshots();
    } else {
      yield* const Stream.empty();
    }
  }


  // =============================
  // Referencia a colección usuarios
  // =============================
  static CollectionReference get _usuariosRef {
    return FirebaseFirestore.instance.collection('usuarios');
  }

  // =============================
  // Obtener todos los usuarios (ADMIN)
  // =============================
  static Stream<QuerySnapshot> obtenerUsuarios() {
    return _usuariosRef.orderBy('nombre').snapshots();
  }

  // =============================
  // Actualizar usuario
  // =============================
  static Future<void> actualizarUsuario({
    required String uid,
    required String nombre,
    required String nombreUsuario,
    required int edad,
  }) async {
    await _usuariosRef.doc(uid).update({
      'nombre': nombre,
      'nombre_usuario': nombreUsuario,
      'edad': edad,
      'fecha_actualizacion': Timestamp.now(),
    });
  }

  // =============================
  // Eliminar usuario (Firestore)
  // =============================
  static Future<void> eliminarUsuario(String uid) async {
    await _usuariosRef.doc(uid).delete();
  }
}

