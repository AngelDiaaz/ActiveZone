import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gymapp/models/models.dart';

class Gym {
  Gym({
    required this.name,
    required this.id,
    required this.direction,
    required this.geolocation,
    required this.instagram,
    required this.activities,
    this.image,
  });

  String name;
  String direction;
  String id;
  GeoPoint geolocation;
  String instagram;
  List<Activity> activities;
  String? image;

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
        geolocation: data?['geolocation'],
        instagram: data?['instagram'],
        image: data?['image']);
  }

  Map<String, dynamic> toFirestore() {
    return {
      "name": name,
      "direction": direction,
      "class": activities,
      "id": id,
      "instagram": instagram,
      "geolocation": geolocation,
      if (image != null) "image": image,
    };
  }

  @override
  String toString() {
    return "Gym --> Id: $id, Name: $name, Direction $direction, Activities: $activities, Instagram: $instagram, Geolocation: $geolocation";
  }
}
