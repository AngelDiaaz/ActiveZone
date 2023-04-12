import 'package:http/http.dart' as http;


class Email {
  Email({
    required this.name,
    required this.email,
    required this.code,
  });

  String name;
  String email;
  String code;
}

