import 'package:gymapp/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginServices {
  List<User> myUsers = [];
  final User userEmpty = User(name: "", password: "", email: "", surname1: "", surname2: "", active: false);

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
    User? user = docSnap.data(); // Convert to City object
    if (user != null) {
      return user;
    } else {
      return userEmpty;
    }
  }

  // Future<User> getUser(String id) async {
  //   DocumentSnapshot snapshot = await db.collection("users").doc("user2").get();
  //   var data = snapshot.data() as Map;
  //
  //   print('hola');
  //
  //
  //   if (snapshot.exists) {
  //     // Obtengo el usuario de la bbdd
  //     User user = User(
  //       password: data.values.elementAt(1),
  //       name: data.values.elementAt(3),
  //       // authenticationCode: data.values.elementAt(5),
  //       email: data.values.elementAt(6),
  //       key: data.values.elementAt(7),
  //       surname1: data.values.elementAt(0),
  //       surname2: data.values.elementAt(2),
  //       // active: data.values.elementAt(4),
  //     );
  //     print('a ' + user.toString());
  //
  //     return user;
  //   }
  //   return userEmpty;
  // }
    /// Metodo que modifica un usuario en la base de datos
    Future<bool> updateUser(String id, User user) async {
      try {
        db.collection("users").doc(id).update({
          "name": user.name,
          "password": user.password,
          "email": user.email,
        });

        return true;
      } catch (e) {
        return false;
      }
    }

    /// Metodo que elimina un usuario de la base de datos
    Future<bool> deleteUser(String key) async {
      try {
        db.collection("users").doc(key).delete();
        return true;
      } catch (e) {
        return false;
      }
    }
  }
