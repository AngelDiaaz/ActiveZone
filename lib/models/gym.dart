import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gymapp/models/models.dart';

class Gym {
  Gym({
    required this.name,
    required this.id,
    required this.direction,
    required this.activities,
  });

  String name;
  String direction;
  String id;
  List<Activity> activities;

  factory Gym.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return Gym(
      name: data?['name'],
      id: data?['id'],
      activities: [],
      direction: data?['direction'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "name": name,
      "direction": direction,
      "class": activities,
      "id": id,
    };
  }

  @override
  String toString() {
    return "Gym --> Id: $id, Name: $name, Direction $direction, Activities: $activities";
  }
}
