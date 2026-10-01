import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/perfil_service.dart';

class PerfilProvider extends ChangeNotifier {
  bool _cargando = true;
  bool _guardando = false;
  String? _errorMessage;

  Map<String, dynamic> _datosPerfil = {};

  bool get cargando => _cargando;
  bool get guardando => _guardando;
  String? get errorMessage => _errorMessage;
  Map<String, dynamic> get datosPerfil => _datosPerfil;

  Future<void> cargarDatos() async {
    _cargando = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        _datosPerfil = await PerfilService.obtenerPerfil(user.uid);
      }
    } catch (e) {
      _errorMessage = 'Error al cargar perfil: $e';
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  Future<bool> guardarCambios({
    required String nombre,
    required String usuario,
    required String edadText,
  }) async {
    _guardando = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('Usuario no autenticado');

      await PerfilService.actualizarPerfil(
        uid: user.uid,
        nombre: nombre,
        usuario: usuario,
        edad: int.tryParse(edadText) ?? 0,
      );

      _guardando = false;
      notifyListeners();
      return true;
    } catch (e) {
      _guardando = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}
