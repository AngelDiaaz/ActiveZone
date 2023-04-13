import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gymapp/pages/change_password.dart';
import '../models/user.dart';
import '../services/services.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var rng = Random();
  AppState? state;

  @override
  Widget build(BuildContext context) {
    // Genero el codigo para poder cambiar la contraseña
    var code = rng.nextInt(900000) + 100000;
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
            // Padding(
            //   padding: const EdgeInsets.only(top: 60.0),
            //   child: Center(
            //     child: SizedBox(
            //         width: 200,
            //         height: 150,
            //         child: Image.asset('assets/images/login.jpg')),
            //   ),
            // ),
            const SizedBox(
              height: 60,
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 15, 40),
              child: Text(
                'Introduce el nombre de usuario y el correo electrónico para cambiar la contraseña',
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
                    final messenger = ScaffoldMessenger.of(context);
                    bool response = false;
                    if (_formKey.currentState!.validate()) {
                      User user = await state!.getUser(userController.text);

                      if (user.name != "" && user.active!) {
                        if (user.name == userController.text &&
                            user.email == emailController.text) {
                          response = true;
                        }
                        if (response) {
                          final send = await sendEmail(
                              code: code.toString(),
                              name: userController.text,
                              email: emailController.text);

                          if (send) {
                            codePopup(code.toString(), user);
                          } else {
                            errorMessage(
                                messenger, 'Error credenciales incorrectas');
                          }
                        } else {
                          errorMessage(
                              messenger, 'Error credenciales incorrectas');
                        }
                      } else {
                        errorMessage(messenger,
                            'No existe esta cuenta o está desactivada');
                      }
                    }
                  },
                  child: const Text(
                    'Enviar correo',
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

  /// Metodo que envia un correo electronico
  Future<bool> sendEmail({
    required String name,
    required String email,
    required String code,
  }) async {
    const serviceId = 'service_lle3xmv';
    const templateId = 'template_lad59wg';
    const userId = '4mYNiIFd_4urj184p';

    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final response = await http.post(url,
        headers: {
          'origin': 'http://localhost',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'service_id': serviceId,
          'template_id': templateId,
          'user_id': userId,
          'template_params': {
            'user_name': name,
            'user_email': email,
            'user_code': code,
          },
        }));
    if (response.body == "OK") {
      return true;
    }
    return false;
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
              controller: userController,
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
              controller: emailController,
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

  /// Metodo que muestra el popup para introducir el codigo que se nos a enviado al correo electronico y poder cambiar la contraseña
  void codePopup(String code, User user) {
    showDialog(
      context: context,
      builder: (_) {
        final TextEditingController codeController = TextEditingController();
        return AlertDialog(
          title: const Text('Inserte el código del correo'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: codeController,
                  decoration: const InputDecoration(hintText: 'Código'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (code == codeController.text) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChangePassword(user: user),
                  ));
                }
              },
              child: const Text('Siguiente'),
            ),
          ],
        );
      },
    );
  }
}
