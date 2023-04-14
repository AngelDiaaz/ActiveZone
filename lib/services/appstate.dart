import 'package:flutter/cupertino.dart';
import 'package:gymapp/models/models.dart';
import 'package:gymapp/services/users_services.dart';

/// Clase AppState
class AppState with ChangeNotifier {
  final User userEmpty = User(dni: "", name: "", password: "", phone: "", email: "", surname1: "", surname2: "", active: false);

  /// Metodo que devuelve un usuario por la ID de la base de datos
  Future<User> getUser(String id) async {
    try {
      return await LoginServices().getUser(id);
    } catch (e) {
      return userEmpty;
    }
  }

  /// Metodo que guarda un usuario de la base de datos
  Future<bool> updateUser(String id, User user) async {
    try {
      bool response = await LoginServices().updateUser(id, user);
      if (response) {
        notifyListeners();
      }
      return response;
    } catch (e) {
      return false;
    }
  }

  /// Metodo que elimina un usuario de la base de datos
  Future<bool> deleteUser(String id) async {
    try {
      bool response = await LoginServices().deleteUser(id);
      if (response) {
        notifyListeners();
      }
      return response;
    } catch (e) {
      return false;
    }
  }
}
