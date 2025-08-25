class Vehicle {
  String company;
  String model;
  String name;
  String plate;
  Vehicle({
    required this.company,
    required this.model,
    required this.name,
    required this.plate,
  });
  Map<String, dynamic> toJson() => {
    "company": company,
    "model": model,
    "name": name,
    "plate": plate,
  };
  factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
    company: json["company"],
    model: json["model"],
    name: json["name"],
    plate: json["plate"],
  );
}
