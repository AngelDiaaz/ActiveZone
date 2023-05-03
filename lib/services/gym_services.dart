import 'package:gymapp/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Clase GymServices
class GymServices {
  // Constantes de las id de las colecciones de la base de datos
  final String collection = 'company';
  final String activity = 'class';
  final String schedule = 'schedule';
  List<Gym> myGyms = [];

  // Inicializo la conexion con la base de datos
  FirebaseFirestore db = FirebaseFirestore.instance;

  /// Metodo que obtiene los gimnasios que hay en la base de datos
  Future<List<Gym>> getGym() async {
    final ref = db.collection(collection).withConverter(
          fromFirestore: Gym.fromFirestore,
          toFirestore: (Gym gym, _) => gym.toFirestore(),
        );

    var docSnap = await ref.get();
    var gyms = <Gym>[];

    // Almaceno todas las actividades de una gimnasio
    for (int i = 0; i < docSnap.docs.length; i++) {
      Gym g = docSnap.docs.elementAt(i).data();
      g.activities = await getActivities(g.id);
      gyms.add(g);
    }
    return gyms;
  }

  /// Metodo que obtiene todas las actividades de un gimnasio
  Future<List<Activity>> getActivities(String id) async {
    final ref =
        db.collection(collection).doc(id).collection(activity).withConverter(
              fromFirestore: Activity.fromFirestore,
              toFirestore: (Activity activity, _) => activity.toFirestore(),
            );

    var docSnap = await ref.get();
    var activities = <Activity>[];

    // Almaceno todas las clases de un gimnasio
    for (int i = 0; i < docSnap.docs.length; i++) {
      Activity a = docSnap.docs.elementAt(i).data();
      a.schedule = await getSchedules(id, a.name);
      activities.add(a);
    }
    return activities;
  }

  /// Metodo que obtiene todos los horarios de una actividad
  Future<List<Schedule>> getSchedules(String id, String activity) async {
    final ref = db
        .collection(collection)
        .doc(id)
        .collection(this.activity)
        .doc(activity)
        .collection(schedule)
        .withConverter(
          fromFirestore: Schedule.fromFirestore,
          toFirestore: (Schedule schedule, _) => schedule.toFirestore(),
        );

    var docSnap = await ref.get();
    var schedules = <Schedule>[];

    // Almaceno todos los usuarios inscritos a una actividad
    for (int i = 0; i < docSnap.docs.length; i++) {
      Schedule s = docSnap.docs.elementAt(i).data();
      s.users = await getClassUsers(id, activity, s.hour);
      schedules.add(s);
    }
    return schedules;
  }

  /// Metodo que obitiene todos los usuarios que hay incritos a una actividad
  Future<List<User>> getClassUsers(
      String id, String activity, String hour) async {
    final ref = db
        .collection(collection)
        .doc(id)
        .collection(this.activity)
        .doc(activity)
        .collection(schedule)
        .doc(hour)
        .collection('users')
        .withConverter(
          fromFirestore: User.fromFirestore,
          toFirestore: (User user, _) => user.toFirestore(),
        );

    var users = <User>[];
    var docSnap = await ref.get();

    // Almaceno todos los usuarios que se han inscrito a una actividad
    for (int i = 0; i < docSnap.docs.length; i++) {
      users.add(docSnap.docs.elementAt(i).data());
    }
    return users;
  }

  /// Metodo que inserta un usuario en una actividad
  Future<bool> insertUserActivity(
      String id, String activity, String hour, User user) async {
    try {
      db
          .collection(collection)
          .doc(id)
          .collection(this.activity)
          .doc(activity)
          .collection(schedule)
          .doc(hour)
          .collection('users')
          .doc(user.dni)
          .set(user.toFirestore());
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Metodo que modifica un gimnasio en la base de datos
  Future<bool> updateGym(String id, Gym gym) async {
    try {
      final updateGym = {
        "direction": gym..direction,
        "name": gym.name,
        "activities": gym.activities,
      };

      db.collection(collection).doc(id).set(updateGym);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Metodo que elimina un gimnasio de la base de datos
  Future<bool> deleteUser(String id) async {
    try {
      db.collection(collection).doc(id).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Metodo que devuelve los horarios de una fecha concreta
  Future<List<Schedule>> getShedulesByDate(
      String date, String id, String activity) async {
    final ref = db
        .collection(collection)
        .doc(id)
        .collection(this.activity)
        .doc(activity)
        .collection(schedule)
        .where("date", isEqualTo: date)
        .withConverter(
          fromFirestore: Schedule.fromFirestore,
          toFirestore: (Schedule schedule, _) => schedule.toFirestore(),
        );

    var docSnap = await ref.get();
    var schedules = <Schedule>[];

    // Almaceno todos los usuarios inscritos a una actividad
    for (int i = 0; i < docSnap.docs.length; i++) {
      Schedule s = docSnap.docs.elementAt(i).data();
      s.users = await getClassUsers(id, activity, s.hour);
      schedules.add(s);
    }
    return schedules;
  }
}
