import 'package:flutter/material.dart';

///Clase LoginSettings
class LoginSettings {
  ///Metodo que devuelve la direccion web de la imagen del login
  static String loginImage() {
    return 'https://img.freepik.com/foto-gratis/deporte-fitness-salud-bicicletas-estaticas-gimnasio_613910-20283.jpg?w=360&t=st=1684577477~exp=1684578077~hmac=af0506c55f5c39d5c606ccf98330ab82e8ea89551327acb1810c1a35758920d';
  }

  ///Metodo que devuelve el color principal del login
  static Color loginColor() {
    return const Color.fromRGBO(67, 68, 82, 0.9);
  }

  ///Metodo con la configuracion que quiero que se muestre en los formularios
  static InputDecoration decorationForm(String labelText, String hintText) {
    return InputDecoration(
      errorStyle: const TextStyle(height: 0),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: loginColor()),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: loginColor()),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: loginColor()),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Colors.red),
      ),
      labelStyle: TextStyle(color: loginColor()),
      labelText: labelText,
      hintText: hintText,
    );
  }
}