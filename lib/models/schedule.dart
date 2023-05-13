import 'package:cloud_firestore/cloud_firestore.dart';

class Schedule {
  Schedule({
    required this.hour,
    this.date,
    this.duration,
    this.numberUsers,
  });

  String hour;
  String? date;
  String? duration;
  int? numberUsers;

  factory Schedule.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Schedule(
        hour: data?['hour'],
        date: data?['date'],
        duration: data?['duration'],
        numberUsers: data?['numberUsers']);
  }

  Map<String, dynamic> toFirestore() {
    return {
      "hour": hour,
      if (duration != null) "duration": duration,
      if (date != null) "date": date,
      if (numberUsers != null) "numberUsers": numberUsers,
    };
  }

  @override
  String toString() {
    return "Schedule --> Hour: $hour, Date: $date, Duration: $duration, Number Users: $numberUsers";
  }
}
