import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gymapp/models/models.dart';
import 'firebase_options.dart';
import '../models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginServices {
  List<User> myUsers = [];
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

  Future<User> getUser(String id) async {
    DocumentSnapshot snapshot = await db.collection("users").doc(id).get();
    var data = snapshot.data() as Map;

    if (snapshot.exists) {
      // Obtengo el usuario de la bbdd
      User user = User(
        password: data.values.elementAt(0),
        name: data.values.elementAt(1),
        authenticationCode: data.values.elementAt(2),
        email: data.values.elementAt(3),
        key: data.values.elementAt(4),
      );
      return user;
    }
    return User(name: "", password: "", email: "");
  }
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
