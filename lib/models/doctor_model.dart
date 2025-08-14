// lib/models/doctor_model.dart
class DoctorModel {
  final int id;
  final String fullName;
  final String email;
  final String? address;
  final String? aboutMe;
  final int? yearsOfExperience;
  final String? specialty;
  final List<dynamic> workingHours;
  final int totalPatients;
  final int totalAppointments;

  DoctorModel({
    required this.id,
    required this.fullName,
    required this.email,
    this.address,
    this.aboutMe,
    this.yearsOfExperience,
    this.specialty,
    required this.workingHours,
    required this.totalPatients,
    required this.totalAppointments,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) => DoctorModel(
       id: (json['id'] as int?) ?? 0,   
        fullName: json['full_name'] as String,
        email: json['email'] as String,
        address: json['address'] as String?,
        aboutMe: json['about_me'] as String?,
        yearsOfExperience: json['years_of_experience'] as int?,
        specialty: json['specialty'] as String?,
        workingHours: List<dynamic>.from(json['working_hours'] ?? []),
        totalPatients: json['total_patients'] as int? ?? 0,
        totalAppointments: json['total_appointments'] as int? ?? 0,
      );
}
