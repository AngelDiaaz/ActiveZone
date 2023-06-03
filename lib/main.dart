import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gymapp/models/models.dart';
import 'package:gymapp/pages/pages.dart';
import 'package:gymapp/pages/reserves/my_reserves.dart';
import 'package:gymapp/services/firebase_options.dart';
import 'package:gymapp/services/services.dart';
import 'package:gymapp/utils/page_settings.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  String? userId = prefs.getString('userId');

  runApp(MyApp(
    isLoggedIn: isLoggedIn,
    userId: userId,
  ));
  // runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key, required this.isLoggedIn, this.userId});

  final bool isLoggedIn;
  final String? userId;
  final AppState state = AppState();

  Future<User> getUser() async {
    // Realiza una operación asíncrona aquí, por ejemplo, una solicitud de red
    if (userId != null) {
      return await state.getUser(userId!);
    } else {
      return User(
          name: "",
          password: "",
          email: "",
          surname1: "",
          surname2: "",
          active: true,
          dni: "",
          phone: "");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUser(),
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          User user = snapshot.data!;
          return ChangeNotifierProvider(
            create: (BuildContext context) => AppState(),
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'ActiveZone+',
              // Declaro las rutas que tiene la app
              routes: {
                '/': (_) =>
                    HomePage(
                      user: user,
                    ),
                'login': (_) =>
                    Login(
                      userId: userId,
                    ),
                'register': (_) => const ActiveAccount(),
                'password': (_) => const ForgotPassword(),
                'my': (_) =>
                    MyReserves(
                      user: user,
                    ),
                'new': (_) =>
                    NewReserve(
                      user: user,
                    ),
                'hour': (_) => InfoNewReserve(user: user, activityName: ''),
                'confirm': (_) =>
                    ConfirmReserve(
                        user: user,
                        schedule: Schedule(
                            id: '',
                            hour: '',
                            numberUsers: 0,
                            date: Timestamp(0, 0)),
                        activityName: '')
              },
              // Inicio la app por la ruta del login
              initialRoute: isLoggedIn ? '/' : 'login',
            ),
          );
        }else {
          // Si ocurrió un error durante la carga
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
                body: Container(
                  color: LoginSettings.loginColor(),
                  child: Center(
                    child: Image.asset('assets/images/gym.jpg'),
                  ),
                ),
              ),
          );
        }
      },
    );
  }
}
