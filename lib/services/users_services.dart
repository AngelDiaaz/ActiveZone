import 'package:firebase_core/firebase_core.dart';
import 'package:gymapp/models/models.dart';
import 'firebase_options.dart';
import '../models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginServices {
  List<User> myUsers = [];

  Future<int> countUsers() async {
    AggregateQuerySnapshot query = await db.collection("users").count().get();
    return query.count;
  }

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
          password: data.values.elementAt(0),
          name: data.values.elementAt(1),
          authenticationCode: data.values.elementAt(2),
          email: data.values.elementAt(3),
          key: data.values.elementAt(4),
        );

        // Añado el usuario de la bbdd en una lista
        myUsers.add(newUser);
      }
    }

    return myUsers;
  }
//
// /// Metodo que inserta un usuario en la base de datos
// Future<bool> saveUser(String user, String password) async {
//   try {
//     await Firebase.initializeApp();
//     await FirebaseDatabase.instance
//         .ref()
//         .child('users')
//         .push()
//         .set({'user': user, 'password': password});
//     return true;
//   } catch (e) {
//     return false;
//   }
// }
//
// /// Metodo que elimina un usuario de la base de datos
// Future<bool> deleteUser(String key) async {
//   try {
//     await FirebaseDatabase.instance.ref().child('users').child(key).remove();
//     return true;
//   } catch (e) {
//     return false;
//   }
// }
}
