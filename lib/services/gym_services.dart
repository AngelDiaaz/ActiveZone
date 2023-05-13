import 'package:gymapp/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

/// Clase GymServices
class GymServices {
  // Constantes de las id de las colecciones de la base de datos
  final String collection = 'company';
  final String gym = 'dumbbell gym malaga';
  final String activity = 'activity';
  final String schedule = 'schedule';
  List<Gym> myGyms = [];

  // Inicializo la conexion con la base de datos
  FirebaseFirestore db = FirebaseFirestore.instance;

  /// Metodo que obtiene los gimnasios que hay en la base de datos
  Future<List<Gym>> getGyms() async {
    final ref = db.collection(collection).withConverter(
          fromFirestore: Gym.fromFirestore,
          toFirestore: (Gym gym, _) => gym.toFirestore(),
        );

    var docSnap = await ref.get();
    var gyms = <Gym>[];

    // Almaceno todas las actividades de una gimnasio
    for (int i = 0; i < docSnap.docs.length; i++) {
      Gym g = docSnap.docs.elementAt(i).data();
      g.activities = await getActivities();
      gyms.add(g);
    }
    return gyms;
  }

  Future<Gym> getGym() async {
    final ref = db.collection(collection).withConverter(
          fromFirestore: Gym.fromFirestore,
          toFirestore: (Gym gym, _) => gym.toFirestore(),
        );

    var docSnap = await ref.get();

    return docSnap.docs.elementAt(0).data();
  }

  /// Metodo que obtiene todas las actividades de un gimnasio
  Future<List<Activity>> getActivities() async {
    final ref =
        db.collection(collection).doc(gym).collection(activity).withConverter(
              fromFirestore: Activity.fromFirestore,
              toFirestore: (Activity activity, _) => activity.toFirestore(),
            );

    var docSnap = await ref.get();
    var activities = <Activity>[];

    // Almaceno todas las clases de un gimnasio
    for (int i = 0; i < docSnap.docs.length; i++) {
      Activity a = docSnap.docs.elementAt(i).data();
      a.schedule = await getSchedules(collection, gym, a.name);
      activities.add(a);
    }
    return activities;
  }

  /// Metodo que obtiene todos los horarios de una actividad
  Future<List<Schedule>> getSchedules(String collection, String id,String activity) async {
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

    // Almaceno todos los horarios en una lista
    for (int i = 0; i < docSnap.docs.length; i++) {
      Schedule s = docSnap.docs.elementAt(i).data();
      schedules.add(s);
    }
    return schedules;
  }

  /// Metodo que obitiene todos los usuarios que hay incritos a una actividad
  Future<List<User>> getClassUsers(String activity, String hourId) async {
    final ref = db
        .collection(collection)
        .doc(gym)
        .collection(this.activity)
        .doc(activity)
        .collection(schedule)
        .doc(hourId)
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
  Future<bool> insertUserActivity(Activity activity, Schedule schedule, User user) async {
    try {
      //Sumo uno al campo de los numeros de usarios en una actividad a una hora concreta
      db
          .collection(collection)
          .doc(gym)
          .collection(this.activity)
          .doc(activity.name)
          .collection(this.schedule)
          .doc(schedule.id)
          .set(schedule.toFirestore());

      //Añado la actividad en el usuario
      db
          .collection('users')
          .doc(user.dni)
          .collection(this.activity)
          .doc(activity.name)
          .set(activity.toFirestore());

      //Añado el horario en la actividad del usuario
      db
          .collection('users')
          .doc(user.dni)
          .collection(this.activity)
          .doc(activity.name)
          .collection(this.schedule)
          .doc(schedule.id)
          .set(schedule.toFirestore());

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Metodo que modifica un gimnasio en la base de datos
  Future<bool> updateGym(Gym gym) async {
    try {
      final updateGym = {
        "direction": gym..direction,
        "name": gym.name,
        "activities": gym.activities,
      };

      db.collection(collection).doc(this.gym).set(updateGym);
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
      String date, String activity) async {
    final ref = db
        .collection(collection)
        .doc(gym)
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
      schedules.add(s);
    }
    return schedules;
  }

  Future<User> getReservesUser(String userDni) async {
    final ref =
        db.collection('users').where("dni", isEqualTo: userDni).withConverter(
              fromFirestore: User.fromFirestore,
              toFirestore: (User user, _) => user.toFirestore(),
            );

    var docSnap = await ref.get();

    User a = docSnap.docs.elementAt(0).data();
    a.activity = await getUserActivity(a);

    return a;
  }

  Future<List<Activity>> getUserActivity(User user) async {
    final ref =
    db.collection('users').doc(user.dni).collection(activity).withConverter(
      fromFirestore: Activity.fromFirestore,
      toFirestore: (Activity activity, _) => activity.toFirestore(),);

    var docSnap = await ref.get();
    var activities = <Activity>[];

    // Almaceno todas las clases de un gimnasio
    for (int i = 0; i < docSnap.docs.length; i++) {
      Activity a = docSnap.docs.elementAt(i).data();
      a.schedule = await getSchedules('users', user.dni, a.name);
      activities.add(a);
    }
    return activities;
  }

  ///Metodo que devuelve la foto de una actividad a traves del nombre de la actividad
  Future<String> getImageActivity(String name) async {
    final ref = db
        .collection(collection)
        .doc(gym)
        .collection(activity)
        .where('name', isEqualTo: name)
        .withConverter(
          fromFirestore: Activity.fromFirestore,
          toFirestore: (Activity activity, _) => activity.toFirestore(),
        );

    var docSnap = await ref.get();

    return docSnap.docs.elementAt(0).data().image;
  }
}
