import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gymapp/models/models.dart';

class Activity {
  Activity({
    required this.name,
    required this.capacity,
    required this.image,
    this.schedule,
  });

  String name;
  int capacity;
  String image;
  List<Schedule>? schedule;

  factory Activity.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Activity(name: data?['name'], capacity: data?['capacity'], image: data?['image'], schedule: []);
  }

  Map<String, dynamic> toFirestore() {
    return {
      "name": name,
      "capacity": capacity,
      "image": image,
      if (schedule != null) "schedule": schedule,
    };
  }

  @override
  String toString() {
    return "Activity --> Name: $name, Capacity: $capacity, Schedule: $schedule";
  }
}
