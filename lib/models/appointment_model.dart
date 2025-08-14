// lib/models/appointment_model.dart

class AppointmentModel {
  final int id;
  final int doctorId;
  final String appointmentDate;
  final int bookedBy;
  final String status;
  final String attendanceStatus;
  final String? notes;

  AppointmentModel({
    required this.id,
    required this.doctorId,
    required this.appointmentDate,
    required this.bookedBy,
    required this.status,
    required this.attendanceStatus,
    this.notes,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: int.tryParse("${json['id']}") ?? 0,
      doctorId: int.tryParse("${json['doctor_id']}") ?? 0,
      appointmentDate: json['appointment_date'] as String,
      bookedBy: int.tryParse("${json['booked_by']}") ?? 0,
      status: json['status'] as String,
      attendanceStatus: json['attendance_status'] as String,
      notes: json['notes'] as String?,
    );
  }
}
