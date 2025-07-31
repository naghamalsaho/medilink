class PatientModel {
  final int id;
  final String fullName;
  final String email;
  final String phone;
  final String age;
  final String? condition;
  final String? lastVisit;
  final String? status;

  PatientModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.age,
    this.condition,
    this.lastVisit,
    this.status,
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      id: json['id'],
      fullName: json['full_name'], // ✅ مش name
      email: json['email'],
      phone: json['phone'],
      age: json['age'].toString(),
      condition: json['condition'],
      lastVisit: json['last_visit'],
      status: json['status'],
    );
  }
}
