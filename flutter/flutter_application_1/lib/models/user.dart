class User {
  final String first_name;
  final String last_name;
  final String email;
  final String password;
  final String address;
  final String phone;
  final String NAID;
  final String dob;

  const User({
    required this.first_name,
    required this.last_name,
    required this.email,
    required this.password,
    required this.address,
    required this.phone,
    required this.NAID,
    required this.dob,
  });

  Map<String, dynamic> toJson() => {
    "first_name": first_name,
    "last_name": last_name,
    "email": email,
    "password": password,
    "address": address,
    "phone": phone,
    "NAID": NAID,
    "dob": dob,
  };

  factory User.fromJson(Map<String, dynamic> json) => User(
    first_name: json["first_name"],
    last_name: json["last_name"],
    email: json["email"],
    password: json["password"],
    address: json["address"],
    phone: json["phone"],
    NAID: json["NAID"],
    dob: json["dob"],
  );
}
