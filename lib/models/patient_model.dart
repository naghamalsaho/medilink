class PatientModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String age;
  final String condition;
  final String lastVisit;
  final String status;

  PatientModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.age,
    required this.condition,
    required this.lastVisit,
    required this.status,
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      age: json['age'].toString(),
      condition: json['condition'],
      lastVisit: json['last_visit'],
      status: json['status'],
    );
  }
}
