import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/services.dart';
import 'package:provider/provider.dart';

class ChangePassword extends StatefulWidget {
  User user;

  ChangePassword({Key? key, required this.user}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordRepeatController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AppState? state;

  @override
  Widget build(BuildContext context) {
    state = Provider.of<AppState>(context, listen: true);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Cambiar contraseña"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 60,
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 15, 40),
              child: Text(
                'Introduce la nueva contraseña',
                style: TextStyle(fontSize: 14),
              ),
            ),
            _credentials(),
            const SizedBox(
              height: 80,
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
                      User user = await state!.getUser(widget.user.name);

                      if (user.name != "" && user.active!) {
                        if (passwordController.text == passwordRepeatController.text) {
                          user.password = passwordController.text;

                          state!.updateUser(widget.user.name, user);
                          response = true;
                        }
                        if (response) {
                          navigator.pushNamed('login');
                        } else {
                          errorMessage(
                              messenger, 'Error las contraseñas no coinciden');
                        }
                      } else {
                        errorMessage(
                            messenger, 'Error credenciales incorrectas');
                      }
                    } else {
                      errorMessage(messenger,
                          'No existe esta cuenta o esta desactivada');
                    }
                  },
                  child: const Text(
                    'Cambiar contraseña',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                );
              }),
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }

  /// Metodo que muestra el error que le pasemos
  void errorMessage(ScaffoldMessengerState messenger, String text) {
    messenger.showSnackBar(SnackBar(
      content: Text(
        text,
        style: const TextStyle(fontSize: 16),
      ),
      backgroundColor: Colors.red,
    ));
  }

  /// Formulario con los campos de usuario y correo electronico
  Form _credentials() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: TextFormField(
              controller: passwordController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Usuario',
                  hintText: 'Introduce el usuario'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Este campo es requerido';
                }
                return null;
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 15.0, right: 15.0, top: 15, bottom: 0),
            child: TextFormField(
              controller: passwordRepeatController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Correo Electrónico',
                  hintText: 'Introduce el correo electrónico'),
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
