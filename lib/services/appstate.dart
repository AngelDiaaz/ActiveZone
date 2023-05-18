import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:gymapp/models/models.dart';
import 'package:gymapp/services/services.dart';

/// Clase AppState
class AppState with ChangeNotifier {
  final User userEmpty = User(
      dni: "",
      name: "",
      password: "",
      phone: "",
      email: "",
      surname1: "",
      surname2: "",
      active: false);

  /// Metodo que devuelve un usuario por la ID de la base de datos
  Future<User> getUser(String id) async {
    try {
      return await LoginServices().getUser(id);
    } catch (e) {
      return userEmpty;
    }
  }

  /// Metodo que guarda un usuario de la base de datos
  Future<bool> updateUser(String id, User user) async {
    try {
      bool response = await LoginServices().updateUser(id, user);
      if (response) {
        notifyListeners();
      }
      return response;
    } catch (e) {
      return false;
    }
  }

  /// Metodo que elimina un usuario de la base de datos
  Future<bool> deleteUser(String id) async {
    try {
      bool response = await LoginServices().deleteUser(id);
      if (response) {
        notifyListeners();
      }
      return response;
    } catch (e) {
      return false;
    }
  }

  /// Metodo que inserta un usuario en una actividad
  Future<bool> insertUserActivity(Activity activity, Schedule schedule, User user) async {
    try {
      await GymServices().insertUserActivity(activity, schedule, user);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Metodo que devuelve todos los gimnasios de la base de datos
  Future<List<Gym>> getAllGyms() async {
    try {
      return await GymServices().getAllGyms();
    } catch (e) {
      return [];
    }
  }

  /// Metodo que devuelve todos los gimnasios de la base de datos
  Future<Gym> getGym() async {
    try {
      return await GymServices().getGym();
    } catch (e) {
      return Gym(name: "", id: "", direction: "", activities: []);
    }
  }

  /// Metodo que obtiene todas las actividades de un gimnasio
  Future<List<Activity>> getActivities(bool schedule) async {
    try {
      return await GymServices().getActivities(schedule);
    } catch (e) {
      return [];
    }
  }

  /// Metodo que obtiene una actividad a traves de su nombre
  Future<Activity> getActivity(String nameActivity) async {
    try {
      return await GymServices().getActivity(nameActivity);
    } catch (e) {
      return Activity(name: '', capacity: 0, image: '');
    }
  }

    /// Metodo que obtiene todos los horarios de una actividad
  Future<List<Schedule>> getSchedules(String collection, String id,String activity) async {
    try {
      return await GymServices().getSchedules(collection, id, activity);
    } catch (e) {
      return [];
    }
  }

  /// Metodo que obtiene todos los horarios en los que esta inscrito un usuario tanto los que
  /// estan finalizados o los que no,   /// dependiendo de lo que le pasemos por el booleano end
  Future<List<Schedule>> getSchedulesForUsers(String collection, String id,String activity, bool end) async {
    try {
      return await GymServices().getSchedulesForUser(collection, id, activity, end);
    } catch (e) {
      return [];
    }
  }

  ///Metodo que elimina una reserva de una actividad de un usuario
  Future<bool> deleteScheduleUser(String activityName, String userDni, Schedule schedule) async {
    try {
      return await GymServices().deleteScheduleUser(activityName, userDni, schedule);
    } catch (e) {
      return false;
    }
  }

    ///Metodo que obtiene un usuario a traves del dni
  Future<User> getReservesUser(String userDni) async {
    try {
      return await GymServices().getReservesUser(userDni);
    } catch (e) {
      return userEmpty;
    }
  }

  ///Metodo que obtiene todas las actividades que esta inscrito un usuario
  Future<List<Activity>> getUserActivity(User user) async {
    try {
      return await GymServices().getUserActivity(user);
    } catch (e) {
      return [];
    }
  }

    /// Metodo que obitiene todos los usuarios que hay incritos a una actividad
  Future<List<User>> getUsers(String activity, String hour) async {
    try {
      return await GymServices().getClassUsers(activity, hour);
    } catch (e) {
      return [];
    }
  }

  /// Metodo que devuelve las horas donde la actividad no esta completa
  List<Schedule> getAvailableSchedules(List<Schedule> schedules, int activityCapacity) {
    List<Schedule> availableSchedules = [];

    for (Schedule s in schedules) {
        if (s.numberUsers < activityCapacity) {
          availableSchedules.add(s);
      }
    }

    return availableSchedules;
  }

  /// Metodo que devuelve los horarios de una fecha concreta
  Future<List<Schedule>> getShedulesByDate(
      Timestamp initialDate, String activity, Timestamp finalDate) async {
    try {
      return await GymServices().getShedulesByDate(initialDate, activity, finalDate);
    } catch (e) {
      return [];
    }
  }

  ///Metodo que devuelve la imagen de una actividad
  Future<String> getImageActivity(String name) async {
    try {
      return await GymServices().getImageActivity(name);
    } catch (e) {
      return 'https://via.placeholder.com/50x50';
    }
  }
}
