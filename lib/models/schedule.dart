import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gymapp/models/models.dart';

class Schedule {
  Schedule({
    required this.users,
    required this.hour,
    this.date,
  });

  List<User> users;
  String hour;
  String? date;

  factory Schedule.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return Schedule(users: [], hour: data?['hour'], date: data?['date']);
  }

  Map<String, dynamic> toFirestore() {
    return {
      "users": users,
      "hour": hour,
      if (date != null) "date": date,
    };
  }

  @override
  String toString() {
    return "Schedule --> Users: $users, Hour: $hour, Date: $date";
  }
}