import 'dart:convert';

import 'package:flutter/material.dart';
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
                    final navigator = Navigator.of(context);
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
                          sendEmail(
                              code: '1',
                              name: userController.text,
                              email: emailController.text);

                          // navigator.pushNamed('/');
                        } else {
                          messenger.showSnackBar(const SnackBar(
                            content: Text(
                              'Error credenciales incorrectas',
                              style: TextStyle(fontSize: 16),
                            ),
                            backgroundColor: Colors.red,
                          ));
                        }
                      } else {
                        messenger.showSnackBar(const SnackBar(
                          content: Text(
                            'No existe esta cuenta o esta desactivada',
                            style: TextStyle(fontSize: 16),
                          ),
                          backgroundColor: Colors.red,
                        ));
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

  Future sendEmail({
    required String name,
    required String email,
    required String code,
  }) async {
    const serviceId = 'service_lle3xmv';
    const templateId = 'template_lad59wg';
    const userId = '_7_zkeSG09dMxYsGG';

    // TODO mirar porque no se llega a enviar el email
    // https://www.youtube.com/watch?v=9HW3MZ_tsdo

    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final response = await http.post(url, headers: {
      'Content-Type': 'aplication/json',
    }, body: json.encode({
      'service_id': serviceId,
      'template_id': templateId,
      'user_id': userId,
      'template_params': {
        'user_name': name,
        'user_email': email,
        'user_code': code,
      },
    }));
    print('Correo enviado');
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
}
