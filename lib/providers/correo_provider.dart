import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/correo_service.dart';

class CorreoProvider extends ChangeNotifier {
  bool _cargando = false;
  String? _errorMessage;

  bool get cargando => _cargando;
  String? get errorMessage => _errorMessage;

  Future<bool> cambiarCorreo({
    required String nuevoCorreo,
    required String password,
  }) async {
    if (nuevoCorreo.isEmpty || password.isEmpty) {
      _errorMessage = 'Completa todos los campos';
      notifyListeners();
      return false;
    }

    _cargando = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await CorreoService.cambiarCorreo(
        nuevoCorreo: nuevoCorreo,
        password: password,
      );
      _cargando = false;
      _errorMessage = null;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _cargando = false;
      switch (e.code) {
        case 'wrong-password':
          _errorMessage = 'Contraseña incorrecta';
          break;
        case 'email-already-in-use':
          _errorMessage = 'Ese correo ya está en uso';
          break;
        case 'requires-recent-login':
          _errorMessage = 'Vuelve a iniciar sesión';
          break;
        default:
          _errorMessage = 'Error al cambiar correo';
      }
      notifyListeners();
      return false;
    } catch (_) {
      _cargando = false;
      _errorMessage = 'Error inesperado';
      notifyListeners();
      return false;
    }
  }
}
