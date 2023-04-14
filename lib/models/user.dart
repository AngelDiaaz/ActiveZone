import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  User({
    this.key,
    required this.name,
    required this.password,
    required this.email,
    this.authenticationCode,
    required this.surname1,
    required this.surname2,
    required this.active,
    required this.dni,
    required this.phone,
  });

  String? key;
  String name;
  String password;
  String email;
  String? authenticationCode;
  String surname1;
  String surname2;
  bool active;
  String dni;
  String phone;

  factory User.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return User(
      name: data?['name'],
      password: data?['password'],
      surname1: data?['surname1'],
      surname2: data?['surname2'],
      email: data?['email'],
      authenticationCode: data?['authentication code'],
      key: data?['key'],
      active: data?['active'],
      dni: data?['dni'],
      phone: data?['phone'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "name": name,
      "password": password,
      "email": email,
      "surname1": surname1,
      "surname2": surname2,
      "dni": dni,
      "active": active,
      "phone": phone,
      if (authenticationCode != null) "authenticationCode": authenticationCode,
      if (key != null) "key": key,
    };
  }

  @override
  String toString() {
    return "User --> DNI: $dni, Name: $name, Phone: $phone, Surname1: $surname1, Surname2: $surname2, Password: $password, Email: $email, Active: $active";
  }
}
