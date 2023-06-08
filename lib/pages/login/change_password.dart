import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gymapp/pages/login/login.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../services/services.dart';
import '../../utils/utils.dart';

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
  AppState state = AppState();
  Color principalColor = AppSettings.loginColor();

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
                        'Cambiar contraseña',
                        style: TextStyle(
                            color: principalColor,
                            fontSize: heightScreen * 0.038,
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
                        'Por favor, introduce la nueva contraseña',
                        style: TextStyle(
                            fontSize: heightScreen * 0.02,
                            color: principalColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: heightScreen * 0.04,
                    ),
                    _credentials(heightScreen),
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
                            final messenger = ScaffoldMessenger.of(context);
                            bool response = false;
                            if (_formKey.currentState!.validate()) {
                              User user = await state.getUser(widget.user.dni);

                              if (passwordController.text ==
                                  passwordRepeatController.text) {
                                user.password =
                                    Hash.encryptText(passwordController.text);

                                state.updateUser(widget.user.dni, user);
                                response = true;
                              }
                              if (response) {
                                //Muestro el mensaje de que se ha activado la cuenta
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30.0))),
                                    contentPadding:
                                        const EdgeInsets.only(top: 20.0),
                                    title: const Text(
                                        'Se ha cambiado la contraseña correctamente',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(wordSpacing: 2)),
                                    icon: Icon(Icons.mood_outlined,
                                        color: Colors.green,
                                        size: heightScreen * 0.08),
                                    backgroundColor: const Color.fromRGBO(
                                        247, 237, 240, 0.85),
                                  ),
                                );
                                //Hago que se muestra el mensaje de la activacion durante dos segundos
                                await Future.delayed(
                                    const Duration(seconds: 2));

                                if(!mounted) return;
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Login(userId: widget.user.dni,),
                                    ),
                                    ModalRoute.withName("login")
                                );
                              } else {
                                Error.errorMessage(
                                    messenger,
                                    'Error las contraseñas no coinciden',
                                    Colors.red);
                              }
                            } else {
                              Error.errorMessage(messenger,
                                  'Error credenciales incorrectas', Colors.red);
                            }
                          },
                          child: Text(
                            'Cambiar contraseña',
                            style: TextStyle(
                                color: const Color.fromRGBO(255, 255, 255, 0.9),
                                fontSize: heightScreen * 0.028,
                                fontFamily: 'Geologica'),
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
                                  fontSize: heightScreen * 0.03,
                                  color: principalColor,
                                  fontFamily: 'Geologica'),
                            ),
                            onPressed: () {
                              FocusManager.instance.primaryFocus?.unfocus();

                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Login(userId: widget.user.dni,),
                                  ),
                                  ModalRoute.withName("login")
                              );
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

  /// Metodo que contiene los formularios con los campos de contraseña y repetir contraseña
  SizedBox _credentials(double heightScreen) {
    return SizedBox(
      height: heightScreen * 0.29,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: passwordController,
                obscureText: true,
                style: TextStyle(
                    fontSize: heightScreen * 0.022,
                    fontWeight: FontWeight.w400,
                    color: principalColor),
                decoration: AppSettings.decorationForm(
                    'Nueva Contraseña', 'Introduce la nueva contraseña'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo es requerido';
                  } else if (value.length < 8) {
                    return 'La contraseña debe tener al menos 8 caracteres';
                  } else if (!value.contains(RegExp(r'[A-Z]'))) {
                    return 'La contraseña debe contener alguna mayúscula';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(
              height: heightScreen * 0.015,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 20.0, top: 15, bottom: 0),
              child: TextFormField(
                controller: passwordRepeatController,
                style: TextStyle(
                    fontSize: heightScreen * 0.022,
                    fontWeight: FontWeight.w400,
                    color: principalColor),
                obscureText: true,
                decoration: AppSettings.decorationForm(
                    'Repitir Nueva Contraseña',
                    'Introduce la nueva contraseña'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo es requerido';
                  } else if (value.length < 8) {
                    return 'La contraseña debe tener al menos 8 caracteres';
                  } else if (!value.contains(RegExp(r'[A-Z]'))) {
                    return 'La contraseña debe contener alguna mayúscula';
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
}
