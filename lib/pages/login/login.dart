import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../services/services.dart';
import 'package:provider/provider.dart';
import '../../utils/utils.dart';
import '../pages.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
  Color principalColor = const Color.fromRGBO(67, 68, 82, 0.9);
  final image =
      'https://img.freepik.com/foto-gratis/deporte-fitness-salud-bicicletas-estaticas-gimnasio_613910-20283.jpg?w=360&t=st=1684577477~exp=1684578077~hmac=af0506c55f5c39d5c606ccf98330ab82e8ea89551327acb1810c1a35758920d';

  @override
  Widget build(BuildContext context) {
    state = Provider.of<AppState>(context, listen: true);
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: SizedBox(
          width: widthScreen,
          height: heightScreen,
          child: Stack(children: [
            //Pongo la foto de fondo de pantalla
            Positioned.fill(
              //Cacheo la imagen para al tener que iniciar mas veces sea mas rapido
              child: CachedNetworkImage(
                imageUrl: image,
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
                        'ActiveZone+',
                        style: TextStyle(
                            color: principalColor,
                            fontSize: 40,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    SizedBox(
                      height: heightScreen * 0.07,
                    ),
                    _credentials(heightScreen),

                    SizedBox(
                      height: heightScreen * 0.032,
                    ),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            height: heightScreen * 0.07,
                            width: widthScreen * 0.65,
                            decoration: BoxDecoration(
                                color: principalColor,
                                borderRadius: BorderRadius.circular(20)),
                            child: MaterialButton(
                              onPressed: () async {
                                //Para quitar el teclado al pulsar el boton
                                FocusScope.of(context).unfocus();

                                final messenger = ScaffoldMessenger.of(context);
                                bool response = false;
                                if (_formKey.currentState!.validate()) {
                                  User user =
                                      await state!.getUser(userController.text);
                                  Gym gym = await state!.getGym();

                                  //Realizo el hash de la contraseña que le paso para compararlo con el de la base de datos
                                  if (user.dni.isNotEmpty && user.active!) {
                                    if (user.dni == userController.text &&
                                        user.password ==
                                            Hash.encryptText(
                                                passwordController.text)) {
                                      response = true;
                                    }
                                    if (response) {
                                      if (!mounted) return;
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => HomePage(
                                                    gym: gym,
                                                    user: user,
                                                  )));
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
                              child: const Text(
                                'Iniciar sesión',
                                style: TextStyle(
                                    color: Color.fromRGBO(255, 255, 255, 0.8),
                                    fontSize: 25),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: heightScreen * 0.03,
                          ),
                          SizedBox(
                              width: widthScreen * 0.65,
                              height: heightScreen * 0.07,
                              child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    side: BorderSide(
                                        width: 1, color: principalColor),
                                  ),
                                  child: Text(
                                    "Activar cuenta",
                                    style: TextStyle(
                                        fontSize: 25, color: principalColor),
                                  ),
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();
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

  ///Metodo que contiene los botones para iniciar sesion y activar la cuenta
  SizedBox _credentials(double heightScreen) {
    return SizedBox(
        height: heightScreen*0.32,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: TextFormField(
                  controller: userController,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: principalColor),
                  decoration: InputDecoration(
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
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 25, 20, 0),
                child: TextFormField(
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: principalColor),
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 20, 0),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        textStyle: TextStyle(
                            fontSize: 18, color: principalColor),
                      ),
                      onPressed: () =>
                          Navigator.pushNamed(context, 'password'),
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
