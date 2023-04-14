import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/services.dart';
import 'package:provider/provider.dart';
import '../utils/utils.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AppState? state;

  @override
  Widget build(BuildContext context) {
    state = Provider.of<AppState>(context, listen: true);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Iniciar sesión"),
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
            _credentials(),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 20),
                    ),
                    onPressed: () => Navigator.pushNamed(context, 'password'),
                    child: const Text('Recuperar contraseña'),
                  ),
                )
              ],
            ),
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

                      if (user.dni.isNotEmpty && user.active) {
                        if (user.dni == userController.text &&
                            user.password == passwordController.text) {
                          response = true;
                        }
                        if (response) {
                          navigator.pushNamed('/');
                        } else {
                          Error.errorMessage(messenger,
                              'Error credenciales incorrectas', Colors.red);
                        }
                      } else {
                        Error.errorMessage(messenger,
                            'No existe esta cuenta o está desactivada', Colors.red);
                      }
                    }
                  },
                  child: const Text(
                    'Iniciar sesión',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                );
              }),
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: 270,
              height: 60,
              child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    side: const BorderSide(width: 1, color: Colors.black12),
                  ),
                  child: const Text(
                    "Activar cuenta",
                    style: TextStyle(fontSize: 25),
                  ),
                  onPressed: () => Navigator.pushNamed(context, 'register')),
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
            //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
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
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 15.0, right: 15.0, top: 15, bottom: 0),
            //padding: EdgeInsets.symmetric(horizontal: 15),
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
        ],
      ),
    );
  }
}
