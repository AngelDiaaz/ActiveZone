import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:convert';
import 'dart:math';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:gymapp/pages/pages.dart';
import '../../models/models.dart';
import '../../services/services.dart';
import '../../utils/utils.dart';

///Clase ForgotPassword
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
  AppState state = AppState();
  Color principalColor = AppSettings.loginColor();

  @override
  Widget build(BuildContext context) {
    // Genero el codigo para poder cambiar la contraseña
    var code = rng.nextInt(900000) + 100000;
    state = Provider.of<AppState>(context, listen: true);
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: widthScreen,
          height: heightScreen,
          child: Stack(children: [
            //Pongo la foto de fondo de pantalla
            Positioned.fill(
              //Cacheo la imagen para al tener que iniciar mas veces sea mas rapido
              child: CachedNetworkImage(
                imageUrl: AppSettings.loginImage(),
                fit: BoxFit.cover,
              ),
            ),
            Center(
              child: Container(
                width: widthScreen - (widthScreen * 0.15),
                height: heightScreen - (heightScreen * 0.25),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(247, 237, 240, 0.85),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: heightScreen * 0.05,
                    ),
                    Center(
                      child: Text(
                        'Recuperar contraseña',
                        style: TextStyle(
                            color: principalColor,
                            fontSize: heightScreen *0.035,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Geologica'),
                      ),
                    ),
                    SizedBox(
                      height: heightScreen * 0.02,
                    ),
                    Divider(
                        color: principalColor,
                        indent: 30,
                        endIndent: 30,
                        thickness: 0.8),
                    SizedBox(
                      height: heightScreen * 0.02,
                    ),
                    Center(
                      child: Text(
                        'Por favor, introduce el usuario y el correo electrónico',
                        style: TextStyle(fontSize: heightScreen * 0.02, color: principalColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: heightScreen * 0.04,
                    ),
                    _credentials(heightScreen),
                    SizedBox(
                      height: heightScreen * 0.005,
                    ),
                    Container(
                      height: heightScreen * 0.085,
                      width: widthScreen * 0.65,
                      decoration: BoxDecoration(
                          color: principalColor,
                          borderRadius: BorderRadius.circular(20)),
                      child: FutureBuilder(builder:
                          (BuildContext context, AsyncSnapshot<List> snapshot) {
                        return MaterialButton(
                          onPressed: () async {
                            final messenger = ScaffoldMessenger.of(context);
                            bool response = false;

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChangePassword(user: User(name: 'name', password: 'password', email: 'email', surname1: 'surname1', surname2: 'surname2', active: true, dni: 'dni', phone: 'phone')),
                                ));

                            if (_formKey.currentState!.validate()) {
                              User user =
                                  await state.getUser(userController.text);

                              //Si el usuario existe y no esta activo
                              if (user.dni.isNotEmpty && user.active!) {
                                if (user.dni == userController.text &&
                                    user.email == emailController.text) {
                                  response = true;
                                }
                                if (response) {
                                  final send = await sendEmail(
                                      code: code.toString(),
                                      name: user.name,
                                      email: emailController.text);

                                  if (send) {
                                    codePopup(code.toString(), user);
                                  } else {
                                    Error.errorMessage(
                                        messenger,
                                        'Error credenciales incorrectas',
                                        Colors.red);
                                  }
                                } else {
                                  Error.errorMessage(
                                      messenger,
                                      'Error credenciales incorrectas',
                                      Colors.red);
                                }
                              } else {
                                Error.errorMessage(
                                    messenger,
                                    'No existe esta cuenta o está desactivada',
                                    Colors.red);
                              }
                            }
                          },
                          child: Text(
                            'Enviar correo',
                            style: TextStyle(
                                color: const Color.fromRGBO(255, 255, 255, 0.9),
                                fontSize: heightScreen*0.034, fontFamily: 'Geologica'),
                          ),
                        );
                      }),
                    ),
                    SizedBox(
                      height: heightScreen * 0.03,
                    ),
                    SizedBox(
                        height: heightScreen * 0.08,
                        width: widthScreen * 0.65,
                        child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              side: BorderSide(width: 1, color: principalColor),
                            ),
                            child: Text(
                              "Cancelar",
                              style: TextStyle(
                                  fontSize: heightScreen*0.034, color: principalColor, fontFamily: 'Geologica'),
                            ),
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              Navigator.pop(context);
                            })),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
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
  SizedBox _credentials(double heightScreen) {
    return SizedBox(
      height: heightScreen * 0.27,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: TextFormField(
                controller: userController,
                style: TextStyle(
                    fontSize: heightScreen*0.026,
                    fontWeight: FontWeight.w400,
                    color: principalColor),
                decoration: AppSettings.decorationForm(
                    'Usuario', 'Introduce el usuario'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo es requerido';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 25, 20, 0),
              child: TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(
                    fontSize: heightScreen*0.026,
                    fontWeight: FontWeight.w400,
                    color: principalColor),
                decoration: AppSettings.decorationForm(
                    'Correo Electrónico', 'Introduce el correo electrónico'),
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
          title: Text('Inserte el código del correo',
              style: TextStyle(color: principalColor)),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: principalColor),
                  controller: codeController,
                  decoration: const InputDecoration(hintText: 'Código'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancelar',
                style: TextStyle(color: principalColor),
              ),
            ),
            TextButton(
              onPressed: () {
                if (code == codeController.text) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChangePassword(user: user),
                      ));
                }
              },
              child: Text(
                'Siguiente',
                style: TextStyle(color: principalColor),
              ),
            ),
          ],
        );
      },
    );
  }
}
