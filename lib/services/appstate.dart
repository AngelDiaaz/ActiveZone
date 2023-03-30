import 'package:flutter/cupertino.dart';
import 'package:gymapp/models/models.dart';
import 'package:gymapp/services/users_services.dart';

class AppState with ChangeNotifier {
  List<User> _myUsers = [];

  /// Metodo que devuelve todos los usuarios de la base de datos
  Future<List<User>> getUsers() async {
    try {
      _myUsers = await LoginServices().getUsers();
      return _myUsers;
    } catch (e) {
      return _myUsers;
    }
  }

  /// Metodo que devuelve un usuario por la ID de la base de datos
  Future<User> getUser(String id) async {
    try {
      return await LoginServices().getUser(id);
    } catch (e) {
      return User(name: "", password: "", email: "");
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
  //
  // /// Metodo que elimina un usuario de la base de datos
  // Future<bool> deleteUser(String key) async {
  //   try {
  //     bool response = await LoginServices().deleteUser(key);
  //     if (response) {
  //       notifyListeners();
  //     }
  //     return response;
  //   } catch (e) {
  //     return false;
  //   }
  // }
}
