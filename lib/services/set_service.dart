import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SetService {

  static Future<void> guardarSet({
    required String nombreSet,
    required String localizacion,
    required String ubicacion,
    // required String imagenUrl,
  }) async {

    final uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(uid)
        .collection('SET')
        .add({
      "fecha de SET": nombreSet,
      "localizacion": localizacion,
      "ubicacion": ubicacion,
      //"imagen": imagenUrl,
      "fecha": DateTime.now(),
    });
  }
}
