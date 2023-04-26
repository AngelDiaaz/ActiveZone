import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gymapp/models/models.dart';
import 'package:gymapp/pages/pages.dart';
import 'package:gymapp/pages/reserve/confirm_reserve.dart';
import 'package:gymapp/services/firebase_options.dart';
import 'package:gymapp/services/services.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Gym gym = Gym(name: "", id: "", direction: "", activities: []);
    User user = User(name: "", password: "", email: "", surname1: "", surname2: "",
        active: true, dni: "", phone: "");
    return ChangeNotifierProvider(
      create: (BuildContext context) => AppState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Notas App',
        // Declaro las rutas que tiene la app
        routes: {
          '/': (_) => HomePage(gym: gym,),
          'login': (_) => const Login(),
          'register': (_) => const ActiveAccount(),
          'password': (_) => const ForgotPassword(),
          'new': (_) => NewReserve(gym: gym,),
          'hour': (_) => ChooseHour(activity: Activity(name: "", capacity: 0, image: "")),
          'confirm': (_) => const ConfirmReserve(users: [])
        },
        // Inicio la app por la ruta del login
        initialRoute: '/',
      ),
    );
  }
}
