class AppLink {
  static const String serverImage = "http://192.168.139.152:8000";
  static const String server = "https://medical.doctorme.site";
  static const String token =
      "uj8b7iZ164ZSMxiyQmPnW04odaij0gNCxj8sjr1kf01f0552";
  //======================================Auth==================================//
  static const String logIn = "$server/api/login";

  // ================= Patients =================
  static const String patients = "$server/api/secretary/patients";

  static String updatePatient(int id) => "$server/api/secretary/patients/$id";

  static String searchPatients(String query) =>
      "$server/api/secretary/patients/search?query=$query";
  // ================= Dashboard =================
  static const String dashboard = "$server/api/secretary/dashboard-stats?";
  static const String todaysAppointments =
      "$server/api/secretary/appointments/today";
}
