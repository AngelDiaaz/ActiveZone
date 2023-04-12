import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gymapp/pages/pages.dart';
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
    return ChangeNotifierProvider(
      create: (BuildContext context) => AppState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Notas App',
        // Declaro las rutas que tiene la app
        routes: {
          '/': (_) => const HomePage(),
          'login': (_) => const Login(),
          'register': (_) => const Register(),
          'password': (_) => const ForgotPassword(),
        },
        // Inicio la app por la ruta del login
        initialRoute: 'login',
      ),
    );
  }
}
