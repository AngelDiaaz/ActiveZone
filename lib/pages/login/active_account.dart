import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gymapp/utils/page_settings.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../services/services.dart';
import '../../utils/utils.dart';

///Clase ActiveAccount
class ActiveAccount extends StatefulWidget {
  const ActiveAccount({Key? key}) : super(key: key);

  @override
  State<ActiveAccount> createState() => _ActiveAccountState();
}

class _ActiveAccountState extends State<ActiveAccount> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordRepeatController =
      TextEditingController();
  final TextEditingController authenticationCodeController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AppState state = AppState();
  Color principalColor = LoginSettings.loginColor();

  @override
  Widget build(BuildContext context) {
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
                imageUrl: LoginSettings.loginImage(),
                fit: BoxFit.cover,
              ),
            ),
            Center(
              child: Container(
                width: widthScreen - (widthScreen * 0.15),
                height: heightScreen - (heightScreen * 0.15),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(247, 237, 240, 0.85),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: heightScreen * 0.04,
                    ),
                    Center(
                      child: Text(
                        'Activar cuenta',
                        style: TextStyle(
                            color: principalColor,
                            fontSize: 36,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    SizedBox(
                      height: heightScreen * 0.04,
                    ),
                    _credentials(heightScreen),
                    SizedBox(
                      height: heightScreen * 0.09,
                    ),
                    Container(
                      height: heightScreen * 0.08,
                      width: widthScreen * 0.65,
                      decoration: BoxDecoration(
                          color: principalColor,
                          borderRadius: BorderRadius.circular(20)),
                      child: FutureBuilder(builder:
                          (BuildContext context, AsyncSnapshot<List> snapshot) {
                        return MaterialButton(
                          onPressed: () async {
                            final navigator = Navigator.of(context);
                            final messenger = ScaffoldMessenger.of(context);
                            bool response = false;
                            if (_formKey.currentState!.validate()) {
                              User user =
                                  await state.getUser(userController.text);

                              if (!user.active! &&
                                  user.authenticationCode ==
                                      authenticationCodeController.text) {
                                if (passwordController.text ==
                                    passwordRepeatController.text) {
                                  // Activo la cuenta para que el usuario pueda iniciar sesion
                                  user.active = true;
                                  user.password =
                                      Hash.encryptText(passwordController.text);

                                  state.updateUser(userController.text, user);
                                  response = true;
                                }
                                if (response) {
                                  navigator.pushNamed('login');
                                } else {
                                  Error.errorMessage(
                                      messenger,
                                      'Error las contraseñas no coinciden',
                                      Colors.red);
                                }
                              } else {
                                Error.errorMessage(
                                    messenger,
                                    'Error de usuario o código de autentificación no valido',
                                    Colors.red);
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
                                  fontSize: 25, color: principalColor),
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

  /// Formulario con los campos de usuario y correo electronico
  SizedBox _credentials(double heightScreen) {
    return SizedBox(
      height: heightScreen*0.4,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextFormField(
                controller: userController,
                decoration: decorationForm('Usuario', 'Introduce tu usuario'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo es requerido';
                  }
                  return null;
                },
              ),
            ),
            // SizedBox(
            //   height: heightScreen * 0.014,
            // ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              child: TextFormField(
                controller: authenticationCodeController,
                decoration: decorationForm('Código autentificación',
                    'Introduce el código de autentificación'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo es requerido';
                  }
                  return null;
                },
              ),
            ),
            // SizedBox(
            //   height: heightScreen * 0.014,
            // ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              child: TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration:
                    decorationForm('Contraseña', 'Introduce la contraseña'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo es requerido';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(
              height: heightScreen * 0.014,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              child: TextFormField(
                controller: passwordRepeatController,
                obscureText: true,
                decoration: decorationForm(
                    'Repetir contraseña', 'Introduce la contraseña'),
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

  InputDecoration decorationForm(String labelText, String hintText) {
    return InputDecoration(
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: principalColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: principalColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: principalColor),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: principalColor),
      ),
      labelStyle: TextStyle(color: principalColor),
      labelText: labelText,
      hintText: hintText,
      errorStyle: const TextStyle(
        color: Colors.red,
        fontSize: 14.0,
      ),
    );
  }
}
