class Login {
  final String email;
  final String password;

  const Login({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
    "email": email,
    "password": password,
  };

  factory Login.fromJson(Map<String, dynamic> json) => Login(
    email: json["email"],
    password: json["password"],
  );
}