import 'package:gymapp/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Clase GymServices
class GymServices {
  final String collection = 'company';
  List<Gym> myGyms = [];

  Gym gymEmpty = Gym(name: "", direction: "", activities: []);

  // Inicializo la conexion con la base de datos
  FirebaseFirestore db = FirebaseFirestore.instance;

  /// Metodo que obtiene un gimnasio de la base de datos a través del id
  Future<Gym> getGym(String id) async {
    final ref = db.collection(collection).doc(id).withConverter(
          fromFirestore: Gym.fromFirestore,
          toFirestore: (Gym gym, _) => gym.toFirestore(),
        );

    final docSnap = await ref.get();
    Gym? gym = docSnap.data();
    if (gym != null) {
      return gym;
    } else {
      return gymEmpty;
    }
  }

  Future<List<Activity>> getActivities(String id) async {
    final ref =
        db.collection(collection).doc(id).collection('class').withConverter(
              fromFirestore: Activity.fromFirestore,
              toFirestore: (Activity activity, _) => activity.toFirestore(),
            );

    return [];
  }

  Future<Schedule> getSchedules(String id) async {
    final ref = db
        .collection(collection)
        .doc(id)
        .collection('class')
        .doc('spinning')
        .collection('schedule')
        .doc('10:00')
        .withConverter(
          fromFirestore: Schedule.fromFirestore,
          toFirestore: (Schedule schedule, _) => schedule.toFirestore(),
        );

    final docSnap = await ref.get();
    Schedule? gym = docSnap.data();
    // if (gym != null) {
    //   return gym;
    // } else {
    //   return null;
    // }

    return gym!;
  }

  Future<User?> getUsers(String id) async {
    final ref = db
        .collection(collection)
        .doc(id)
        .collection('class')
        .doc('spinning')
        .collection('schedule')
        .doc('10:00')
        .collection('users')
        .withConverter(
          fromFirestore: User.fromFirestore,
          toFirestore: (User user, _) => user.toFirestore(),
        );

    const users = <User>[];

    final docSnap = await ref.snapshots().toList();
    print(docSnap);
    // User? gym = docSnap.data();

    return null;
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
}
