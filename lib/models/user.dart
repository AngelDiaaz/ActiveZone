class User {
  User({
    this.key,
    required this.name,
    required this.password,
    required this.email,
    this.authenticationCode,
    required this.surname1,
    required this.surname2,
    this.active,
  });

  String? key;
  String name;
  String password;
  String email;
  String? authenticationCode;
  String surname1;
  String surname2;
  bool? active;

  @override
  String toString() {
    return "User --> Name: $name, Surname1: $surname1, Surname2: $surname2, Password: $password, Email: $email, Active: $active";
  }
}
