import 'package:crypto/crypto.dart';
import 'dart:convert';

///Clase Hash
class Hash{
  ///Metodo que realiza un hash con algoritmo SHA-256 de un texto que le pasemos
  static String encryptText(String password){
    return sha256.convert( utf8.encode(password)).toString();
  }
}