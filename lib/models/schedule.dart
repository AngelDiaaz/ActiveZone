import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gymapp/models/models.dart';

class Schedule {
  Schedule({
    this.users,
    required this.hour,
    this.date,
    this.duration,
  });

  List<User>? users;
  String hour;
  String? date;
  String? duration;

  factory Schedule.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return Schedule(users: [], hour: data?['hour'], date: data?['date'], duration: data?['duration']);
  }

  Map<String, dynamic> toFirestore() {
    return {
      "hour": hour,
      if (duration != null) "duration": duration,
      if (users != null) "users": users,
      if (date != null) "date": date,
    };
  }

  @override
  String toString() {
    return "Schedule --> Users: $users, Hour: $hour, Date: $date, Duration: $duration";
  }
}
