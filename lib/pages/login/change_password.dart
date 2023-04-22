import 'package:flutter/material.dart';
import 'package:gymapp/utils/error_message.dart';
import '../../models/models.dart';
import '../../services/services.dart';
import 'package:provider/provider.dart';

/// Clase ChangePassword
class ChangePassword extends StatefulWidget {
  final User user;

  const ChangePassword({Key? key, required this.user}) : super(key: key);

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
                      User user = await state!.getUser(widget.user.dni);

                      if (passwordController.text ==
                          passwordRepeatController.text) {
                        user.password = passwordController.text;

                        state!.updateUser(widget.user.dni, user);
                        response = true;
                      }
                      if (response) {
                        navigator.pushNamed('login');
                      } else {
                        Error.errorMessage(messenger,
                            'Error las contraseñas no coinciden', Colors.red);
                      }
                    } else {
                      Error.errorMessage(messenger,
                          'Error credenciales incorrectas', Colors.red);
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
              obscureText: true,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nueva Contraseña',
                  hintText: 'Introduce la nueva contraseña'),
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
              obscureText: true,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Repitir Nueva Contraseña',
                  hintText: 'Introduce la nueva contraseña'),
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
