import 'package:flutter/material.dart';

class Error{
  /// Metodo que muestra el error que le pasemos
  static void errorMessage(ScaffoldMessengerState messenger, String text, Color color) {
    messenger.showSnackBar(SnackBar(
      content: Text(
        text,
        style: const TextStyle(fontSize: 16),
      ),
      backgroundColor: color,
    ));
  }
}

