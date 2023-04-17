import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gymapp/models/models.dart';

class Gym {
  Gym({
    required this.name,
    required this.direction,
    required this.activities,
  });

  //TODO mirar esto para el mapeado de colecciones dentro de colecciones
  // https://firebase.google.com/docs/firestore/data-model?hl=es-419#:~:text=It%20can%27t%20directly%20contain,within%20a%20collection%20are%20unique.
  // final messageRef = db
  //     .collection("rooms")
  //     .doc("roomA")
  //     .collection("messages")
  //     .doc("message1");

  String name;
  String direction;
  List<Activity> activities;

  factory Gym.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return Gym(
      name: data?['name'],
      activities: data?['class'],
      direction: data?['direction'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "name": name,
      "direction": direction,
      "class": activities,
    };
  }

  @override
  String toString() {
    return "Gym --> Name: $name, Direction $direction, Activities: $activities";
  }
}
