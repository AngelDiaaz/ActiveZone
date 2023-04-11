import 'package:gymapp/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginServices {
  List<User> myUsers = [];
  final User userEmpty = User(
      name: "",
      password: "",
      email: "",
      surname1: "",
      surname2: "",
      active: false);

  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<List<User>> getUsers() async {
    CollectionReference user = db.collection("users");

    int number = 1;

    // Realizo una consulta con el numero de usuarios que hay en la bbdd
    AggregateQuerySnapshot query = await user.count().get();

    for (var i = 0; i < query.count; i++) {
      // Recorro todos los usuarios de la bbdd
      DocumentSnapshot snapshot = await user.doc("user$number").get();
      var data = snapshot.data() as Map;

      number++;

      if (snapshot.exists) {
        // Obtengo el usuario de la bbdd
        User newUser = User(
          password: data.values.elementAt(1),
          name: data.values.elementAt(3),
          authenticationCode: data.values.elementAt(5),
          email: data.values.elementAt(6),
          key: data.values.elementAt(7),
          surname1: data.values.elementAt(0),
          surname2: data.values.elementAt(2),
          active: data.values.elementAt(4),
        );

        // Añado el usuario de la bbdd en una lista
        myUsers.add(newUser);
      }
    }

    return myUsers;
  }

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
        "name": user.name,
        "password": user.password,
        "email": user.email,
        "surname1": user.surname1,
        "surname2": user.surname2,
        "active": user.active,
        "key": user.key,
        "authentication code": user.authenticationCode
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
