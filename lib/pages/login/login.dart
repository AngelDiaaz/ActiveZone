import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../services/services.dart';
import 'package:provider/provider.dart';
import '../../utils/utils.dart';
import '../pages.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

///Clase Login
class Login extends StatefulWidget {
  const Login({Key? key, this.userId}) : super(key: key);

  final String? userId;

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
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
                  height: heightScreen * 0.045,
                ),
                Center(
                  child: Text(
                    'ActiveZone+',
                    style: TextStyle(
                        color: principalColor,
                        fontSize: heightScreen * 0.058,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Geologica'),
                  ),
                ),
                SizedBox(
                  height: heightScreen * 0.045,
                ),
                _credentials(heightScreen),
                SizedBox(
                  height: heightScreen * 0.035,
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Container(
                    height: heightScreen * 0.08,
                    width: widthScreen * 0.65,
                    decoration: BoxDecoration(
                        color: principalColor,
                        borderRadius: BorderRadius.circular(20)),
                    child: MaterialButton(
                      onPressed: () async {
                        //Para quitar el teclado al pulsar el boton
                        FocusManager.instance.primaryFocus?.unfocus();

                        final messenger = ScaffoldMessenger.of(context);
                        bool response = false;
                        if (_formKey.currentState!.validate()) {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          User user;
                          if (userController.text.isNotEmpty) {
                            user = await state.getUser(userController.text);
                          } else {
                            user = await state.getUser(widget.userId!);
                          }

                          //Realizo el hash de la contraseña que le paso para compararlo con el de la base de datos
                          if (user.dni.isNotEmpty && user.active!) {
                            if (user.dni == userController.text &&
                                user.password ==
                                    Hash.encryptText(passwordController.text)) {
                              response = true;
                            }
                            if (response) {
                              //Para guardar en el cache si se ha iniciado sesion antes y el id del usuario
                              prefs.setBool('isLoggedIn', true);
                              prefs.setString('userId', userController.text);

                              if (!mounted) return;
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomePage(
                                            user: user,
                                          )));
                            } else {
                              Error.errorMessage(messenger,
                                  'Error credenciales incorrectas', Colors.red);
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
                        'Iniciar sesión',
                        style: TextStyle(
                            color: const Color.fromRGBO(255, 255, 255, 0.9),
                            fontSize: heightScreen * 0.034, fontFamily: 'Geologica'),
                      ),
                    ),
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
                            "Activar cuenta",
                            style: TextStyle(
                                fontSize: heightScreen * 0.034,
                                color: principalColor, fontFamily: 'Geologica'),
                          ),
                          onPressed: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            Navigator.pushNamed(context, 'register');
                          })),
                ]),
              ],
            ),
          ),
        ),
      ]),
    )));
  }

  ///Metodo que contiene los formularios con los campos de usuario y contraseña, y el boton de recuperar contraseña
  SizedBox _credentials(double heightScreen) {
    return SizedBox(
      height: heightScreen * 0.32,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: TextFormField(
                controller: userController,
                style: TextStyle(
                    fontSize: heightScreen * 0.026,
                    fontWeight: FontWeight.w400,
                    color: principalColor),
                decoration: AppSettings.decorationForm(
                    'Usuario', 'Introduce tu usuario'),
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
                style: TextStyle(
                    fontSize: heightScreen * 0.026,
                    fontWeight: FontWeight.w400,
                    color: principalColor),
                controller: passwordController,
                obscureText: true,
                decoration: AppSettings.decorationForm(
                    'Contraseña', 'Introduce la contraseña'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo es requerido';
                  }
                  return null;
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 20, 0),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      textStyle: TextStyle(
                          fontSize: heightScreen * 0.023,
                          color: principalColor),
                    ),
                    onPressed: () => Navigator.pushNamed(context, 'password'),
                    child: Text('Recuperar contraseña',
                        style: TextStyle(color: principalColor)),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
