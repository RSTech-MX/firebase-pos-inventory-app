import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CorreoService {
  static Future<void> cambiarCorreo({
    required String nuevoCorreo,
    required String password,
  }) async {
    User user = FirebaseAuth.instance.currentUser!;

    // Re-autenticación obligatoria
    AuthCredential cred = EmailAuthProvider.credential(
      email: user.email!,
      password: password,
    );

    await user.reauthenticateWithCredential(cred);

    // Cambiar correo en Auth
    await user.updateEmail(nuevoCorreo.trim());

    // Actualizar Firestore
    await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(user.uid)
        .update({
      'correo': nuevoCorreo.trim(),
    });
  }
}
