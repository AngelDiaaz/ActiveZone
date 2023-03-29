class User {
  User({
    this.key,
    required this.name,
    required this.password,
    required this.email,
    this.authenticationCode,
  });

  String? key;
  String name;
  String password;
  String email;
  String? authenticationCode;

  @override
  String toString() {
    return "User --> Name: $name Password: $password Email: $email";
  }
}