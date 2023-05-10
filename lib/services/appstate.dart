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
  Future<bool> insertUserActivity(
      String id, String activity, String hour, User user) async {
    try {
      await GymServices().insertUserActivity(id, activity, hour, user);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Metodo que devuelve todos los gimnasios de la base de datos
  Future<List<Gym>> getGyms() async {
    try {
      return await GymServices().getGyms();
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
  Future<List<Activity>> getActivities(String id) async {
    try {
      return await GymServices().getActivities(id);
    } catch (e) {
      return [];
    }
  }

  /// Metodo que obtiene todos los horarios de una actividad
  Future<List<Schedule>> getSchedules(String id, String activity) async {
    try {
      return await GymServices().getSchedules(id, activity);
    } catch (e) {
      return [];
    }
  }

  /// Metodo que obitiene todos los usuarios que hay incritos a una actividad
  Future<List<User>> getUsers(String id, String activity, String hour) async {
    try {
      return await GymServices().getClassUsers(id, activity, hour);
    } catch (e) {
      return [];
    }
  }

  /// Metodo que devuelve las horas donde la actividad no esta completa
  List<Schedule> getAvailableSchedules(List<Schedule> schedules, int activityCapacity) {
    List<Schedule> availableSchedules = [];

    for (Schedule s in schedules) {
      if (s.users != null) {
        if (s.users!.length < activityCapacity) {
          availableSchedules.add(s);
        }
      }
    }

    return availableSchedules;
  }

  /// Metodo que devuelve los horarios de una fecha concreta
  Future<List<Schedule>> getShedulesByDate(
      String date, String id, String activity) async {
    try {
      return await GymServices().getShedulesByDate(date, id, activity);
    } catch (e) {
      return [];
    }
  }

  ///Metodo que devuelve la imagen de una actividad
  Future<String> getImageActivity(String id, String name) async {
    try {
      return await GymServices().getImageActivity(id, name);
    } catch (e) {
      return 'https://via.placeholder.com/50x50';
    }
  }
}
