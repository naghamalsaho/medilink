class AppLink {
  static const String serverImage = "http://192.168.139.152:8000";
  static const String server = "https://medical.doctorme.site";

  //======================================Auth==================================//
  static const String logIn = "$server/api/login";

  // ================= Patients =================
  static const String patients = "$server/api/secretary/patients";

  static String updatePatient(int id) => "$server/api/secretary/patients/$id";
}
