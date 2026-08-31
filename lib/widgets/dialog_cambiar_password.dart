import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DialogCambiarPassword {
  static void mostrar(BuildContext context) {
    final passwordActualCtrl = TextEditingController();
    final passwordNuevaCtrl = TextEditingController();
    bool cargando = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Cambiar contraseña'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: passwordActualCtrl,
                    obscureText: true,
                    decoration:
                    const InputDecoration(labelText: 'Contraseña actual'),
                  ),
                  TextField(
                    controller: passwordNuevaCtrl,
                    obscureText: true,
                    decoration:
                    const InputDecoration(labelText: 'Nueva contraseña'),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                cargando
                    ? const Padding(
                  padding: EdgeInsets.all(8),
                  child: CircularProgressIndicator(),
                )
                    : ElevatedButton(
                  child: const Text('Guardar'),
                  onPressed: () async {
                    if (passwordActualCtrl.text.isEmpty ||
                        passwordNuevaCtrl.text.length < 6) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Datos inválidos'),
                        ),
                      );
                      return;
                    }

                    setState(() => cargando = true);

                    try {
                      User user =
                      FirebaseAuth.instance.currentUser!;

                      AuthCredential cred =
                      EmailAuthProvider.credential(
                        email: user.email!,
                        password: passwordActualCtrl.text,
                      );

                      await user
                          .reauthenticateWithCredential(cred);

                      await user.updatePassword(
                          passwordNuevaCtrl.text);

                      Navigator.pop(context);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                          Text('Contraseña actualizada'),
                        ),
                      );
                    } on FirebaseAuthException catch (e) {
                      String msg = 'Error';

                      if (e.code == 'wrong-password') {
                        msg = 'Contraseña incorrecta';
                      } else if (e.code == 'weak-password') {
                        msg = 'Contraseña muy débil';
                      } else if (e.code ==
                          'requires-recent-login') {
                        msg = 'Vuelve a iniciar sesión';
                      }

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(msg)),
                      );
                    } finally {
                      setState(() => cargando = false);
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
