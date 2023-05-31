import 'package:gymapp/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Clase LoginServices
class LoginServices {
  List<User> myUsers = [];
  final User userEmpty = User(
      dni: "",
      name: "",
      password: "",
      phone: "",
      email: "",
      surname1: "",
      surname2: "",
      active: false);

  // Inicializo la conexion con la base de datos
  FirebaseFirestore db = FirebaseFirestore.instance;

  /// Metodo que obtiene un usuario de la base de datos a través del id
  Future<User> getUser(String id) async {
    final ref = db.collection("users").doc(id).withConverter(
          fromFirestore: User.fromFirestore,
          toFirestore: (User user, _) => user.toFirestore(),
        );

    final docSnap = await ref.get();
    User? user = docSnap.data();
    if (user != null) {
      return user;
    } else {
      return userEmpty;
    }
  }

  /// Metodo que modifica un usuario en la base de datos
  Future<bool> updateUser(String id, User user) async {
    try {
      final updateUser = {
        "dni": user.dni,
        "name": user.name,
        "password": user.password,
        "phone": user.phone,
        "email": user.email,
        "surname1": user.surname1,
        "surname2": user.surname2,
        "active": user.active,
        "key": user.key,
        "authentication code": user.authenticationCode,
        'imageProfile': user.imageProfile
      };

      db.collection("users").doc(id).set(updateUser);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Metodo que elimina un usuario de la base de datos
  Future<bool> deleteUser(String id) async {
    try {
      db.collection("users").doc(id).delete();
      return true;
    } catch (e) {
      return false;
    }
  }
}
