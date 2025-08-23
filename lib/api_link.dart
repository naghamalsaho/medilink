class AppLink {
  static const String serverimage = "http://192.168.139.152:8000";
  static const String server =
      "https://cors-anywhere.herokuapp.com/https://medical.doctorme.site";

  //======================================Auth==================================//
  static const String logIn = "$server/api/login";

  // ================= Patients =================
  static const String patients = "$server/api/secretary/patients";
  static String deletePatient(int patientId) =>
      "$server/api/secretary/patients/$patientId";
  static String updatePatient(int id) => "$server/api/secretary/patients/$id";
  static String searchPatients(String query) =>
      "$server/api/secretary/patients/search?query=$query";
  // Profile
  static const String profile = "$server/api/secretary/profile";
  static const String updateProfile = profile; // PUT
  static const String uploadPhoto = "$server/api/secretary/profile/photo";

  // Doctors
  static const getDoctors = "$server/api/secretary/doctors";
  static const String doctorsSearch = "$server/api/secretary/doctors/search";
  static String doctorAppointments(String id) =>
      "$server/api/secretary/doctors/$id/appointments";

  //appointment
  static const String appointmentStats =
      "$server/api/secretary/appointment-requests-stats";
  static const String appointmentRequests =
      "$server/api/secretary/appointment-requests";
  static const String appointmentToday =
      "$server/api/secretary/appointments/today";
  static const String bookAppointment =
      "$server/api/secretary/doctors/book-appointment";
  static String approve(String id) =>
      "$server/api/secretary/appointment-requests/$id/approve";
  static String reject(String id) =>
      "$server/api/secretary/appointment-requests/$id/reject";
  static const String delete = "$server/api/secretary/appointments";
  static const String update = "$server/api/secretary/appointments";

  // ================= Dashboard =================
  static const String dashboard = "$server/api/secretary/dashboard-stats?";
  static const String todaysAppointments =
      "$server/api/secretary/appointments/today";

  // Admin Endpoints
  static const String doctorsApi = '$server/api/admin/doctors';
  static const String token =
      'upBrSSBCocYeUMaHtvpK9opS36lkrWPZHo5puXj91ef07fe6';
  static const String secretariesApi = '$server/api/admin/secretaries';
  // رابط حذف سكرتير حسب الـ id
  static String deleteSecretary(int id) => "$server/api/admin/secretaries/$id";
  static String updateSecretary(int id) => "$server/api/admin/secretaries/$id";
  static const String addSecretary =
      "https://medical.doctorme.site/api/admin/add-user-role";

  // 🟢 ساعات العمل (إضافة / عرض / تعديل / حذف)
  static String workingHours(int doctorId) {
    return "$server/admin/doctors/$doctorId/working-hours";
  }

  // تعديل ساعة العمل حسب ID
  static String updateWorkingHour(int workingHourId) =>
      "https://medical.doctorme.site/api/admin/doctors/working-hours/$workingHourId";

  // حذف ساعة العمل حسب ID
  static String deleteWorkingHour(int workingHourId) =>
      "$server/admin/doctors/working-hours/$workingHourId";
}
