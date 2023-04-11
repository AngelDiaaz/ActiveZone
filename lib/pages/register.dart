import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../services/services.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordRepeatController =
      TextEditingController();
  final TextEditingController authenticationCodeController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AppState? state;

  @override
  Widget build(BuildContext context) {
    state = Provider.of<AppState>(context, listen: true);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Activar cuenta"),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 60,
            ),
            _credentials(),
            const SizedBox(
              height: 70,
            ),
            Container(
              height: 60,
              width: 270,
              decoration: BoxDecoration(
                  color: Colors.lightBlue,
                  borderRadius: BorderRadius.circular(20)),
              child: FutureBuilder(builder:
                  (BuildContext context, AsyncSnapshot<List> snapshot) {
                return MaterialButton(
                  onPressed: () async {
                    final navigator = Navigator.of(context);
                    final messenger = ScaffoldMessenger.of(context);
                    bool response = false;
                    if (_formKey.currentState!.validate()) {
                      User user = await state!.getUser(userController.text);

                      if (!user.active! &&
                          user.authenticationCode ==
                              authenticationCodeController.text) {
                        if (passwordController.text ==
                            passwordRepeatController.text) {
                          // Activo la cuenta para que usuario pueda iniciar sesion
                          user.active = true;
                          user.password = passwordController.text;

                          state!.updateUser(userController.text, user);
                          response = true;
                        }
                        if (response) {
                          navigator.pushNamed('login');
                        } else {
                          messenger.showSnackBar(const SnackBar(
                            content: Text(
                              'Error las contraseñas no coinciden',
                              style: TextStyle(fontSize: 16),
                            ),
                            backgroundColor: Colors.red,
                          ));
                        }
                      } else {
                        messenger.showSnackBar(const SnackBar(
                          content: Text(
                            'Error de usuario o código de autentificación no valido',
                            style: TextStyle(fontSize: 16),
                          ),
                          backgroundColor: Colors.red,
                        ));
                      }
                    }
                  },
                  child: const Text(
                    'Activar cuenta',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                );
              }),
            ),
            const SizedBox(
              height: 130,
            ),
          ],
        ),
      ),
    );
  }

  Form _credentials() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: TextFormField(
              controller: userController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Usuario',
                  hintText: 'Introduce tu usuario'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Este campo es requerido';
                }
                return null;
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 15.0, right: 15.0, top: 15, bottom: 0),
            child: TextFormField(
              controller: authenticationCodeController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Código autentificación',
                  hintText: 'Introduce el código de autentificación'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Este campo es requerido';
                }
                return null;
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 15.0, right: 15.0, top: 15, bottom: 0),
            child: TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Contraseña',
                  hintText: 'Introduce la contraseña'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Este campo es requerido';
                }
                return null;
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 15.0, right: 15.0, top: 15, bottom: 0),
            child: TextFormField(
              controller: passwordRepeatController,
              obscureText: true,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Repetir contraseña',
                  hintText: 'Introduce la contraseña'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Este campo es requerido';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }
}
