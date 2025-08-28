class Vehicle {
  String company;
  String car_model;
  String license_plate;
  DateTime subscription_start;
  int user_id;
  int plan_id;

  Vehicle({
    required this.company,
    required this.car_model,
    required this.license_plate,
    required this.subscription_start,
    required this.user_id,
    required this.plan_id,
  });

  // Convert Vehicle object to JSON
  Map<String, dynamic> toJson() => {
    "company": company,
    "car_model": car_model,  // Ensure key matches the class property
    "license_plate": license_plate,
    "subscription_start": subscription_start.toIso8601String(),  // Convert DateTime to String
    "user_id": user_id,
    "plan_id": plan_id,
  };

  // Convert JSON back to Vehicle object
  factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
    company: json["company"],
    car_model: json["car_model"],  // Ensure key matches the class property
    license_plate: json["license_plate"],
    subscription_start: DateTime.parse(json["subscription_start"]),  // Parse DateTime from String
    user_id: json["user_id"],
    plan_id: json["plan_id"],
  );
}
