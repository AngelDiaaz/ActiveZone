import 'package:firebase_core/firebase_core.dart';
import 'package:gymapp/models/models.dart';
import 'firebase_options.dart';
import '../models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginServices {
  List<User> myUsers = [];

  FirebaseFirestore db = FirebaseFirestore.instance;
  Future<List<User>> pruebasUsers() async {
    CollectionReference user = db.collection("users");

    DocumentSnapshot snapshot = await user.doc("user1").get();
    var data = snapshot.data() as Map;
    var userData = data["user1"];


    //TODO seguir aqui
    print(data.containsValue('pepe'));

    if (snapshot.exists) {
      for (var i = 0; i <data.length; i++) {
        var key = userData.elementAt(i).key;
        dynamic value = userData.elementAt(i).value;
        Map map = {'key': key, ...value};

        print(userData);
        print('aaa');

        // Mapeo la informacion en un nuevo usuario
        User newUser = User(
          password: map['password'],
          key: map['key'],
          name: map['name'],
          email: map['email'],
        );

        // Añado el usuario de la base de datos en una lista
        myUsers.add(newUser);
      }
    }
    return myUsers;

    List<User> users = <User>[];
    final doc = await FirebaseFirestore.instance.collection('users').doc("user1").get();
    print(doc.data().toString());

    return users;
  }
  // /// Metodo que obtiene y devuelve todos los usuarios de la base de datos
  // Future<List<User>> getUsers() async {
  //   List<User> myUsers = [];
  //   try {
  //     await Firebase.initializeApp(
  //       options: DefaultFirebaseOptions.currentPlatform,
  //     );
  //
  //     final user = db.collection("users");
  //
  //
  //     DatabaseEvent snap = db.collection("user").snapshots();
  //
  //     if (snap.snapshot.exists) {
  //       for (var i = 0; i < snap.snapshot.children.length; i++) {
  //         var key = snap.snapshot.children.elementAt(i).key;
  //         dynamic value = snap.snapshot.children.elementAt(i).value;
  //         Map map = {'key': key, ...value};
  //
  //         // Mapeo la informacion en un nuevo usuario
  //         User newUser = User(
  //           password: map['password'],
  //           key: map['key'],
  //           user: map['user'],
  //         );
  //
  //         // Añado el usuario de la base de datos en una lista
  //         myUsers.add(newUser);
  //       }
  //     }
  //     return myUsers;
  //   } catch (e) {
  //     return myUsers;
  //   }
  // }
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
