import 'package:get/get.dart';
import 'package:medilink/core/services/MyServices.dart';

class AppLink {
  // ================= Base URLs =================
  static const String serverimage = "http://192.168.139.152:8000";
  static const String server =
      "https://cors-anywhere.herokuapp.com/https://medical.doctorme.site";

  // ================= Auth =================
  static const String logIn = "$server/api/login";
  static const String logout = "$server/api/logout";

  // ================= Tokens =================
  static String get token => Get.find<MyServices>().box.read("token") ?? "";

  // static const String secretaryToken =
  //     "235|XBNTPLXo4ikK84PgqZZq3oeonkxtAhdW1UEaYyl3952ff102";
  // static const String adminToken =
  //     "2|86R9fr5lgjetWThLzA9cV3VzhnFPG2VnzACwx0bQ7202a532";
  // static const String superAdminToken =
  //     "2|86R9fr5lgjetWThLzA9cV3VzhnFPG2VnzACwx0bQ7202a532";

  // ================= Secretary Endpoints =================
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
  static const String appointmentIgnored =
      "$server/api/secretary/appointment-requests/ignored";
  static const String appointmentAttendance =
      "$server/api/secretary/appointments";
  // Dashboard
  static const String dashboard = "$server/api/secretary/dashboard-stats?";
  static const String todaysAppointments =
      "$server/api/secretary/appointments/today";
  // ================= Secretary Medical Files =================
  static String medicalFiles(int patientId) =>
      "$server/api/secretary/patients/$patientId/medical-file";

  static String uploadMedicalFile(int patientId) =>
      "$server/api/secretary/patients/$patientId/upload-medical-file";

  static String deleteMedicalFile(int patientId, int fileId) =>
      "$server/api/secretary/patients/$patientId/medical-file/$fileId";

  // روابط السكرتيرة
  static String secretaryReportWeek() =>
      "https://medical.doctorme.site/api/secretary/reports/secretary-detailed?scope=week";

  static String secretaryReportDay() =>
      "https://medical.doctorme.site/api/secretary/reports/secretary-detailed?scope=day";

  static String secretaryReportCustom({
    required String from,
    required String to,
  }) =>
      "https://medical.doctorme.site/api/secretary/reports/secretary-detailed?from=$from&to=$to";

  // ================= Admin Endpoints =================
  static const String doctorsApi = '$server/api/admin/doctors';
  // Admin Dashboard
  static const String adminDashboard = "$server/api/admin/dashboard";

  static const String secretariesApi = '$server/api/admin/secretaries';
  static String deleteSecretary(int id) => "$server/api/admin/secretaries/$id";
  static String updateSecretary(int id) => "$server/api/admin/secretaries/$id";
  static const String addSecretary = "$server/api/admin/add-user-role";

  // Working hours
  static String workingHours(int doctorId) {
    return "$server/admin/doctors/$doctorId/working-hours";
  }

  static String updateWorkingHour(int workingHourId) =>
      "https://medical.doctorme.site/api/admin/doctors/working-hours/$workingHourId";
  static String deleteWorkingHour(int workingHourId) =>
      "$server/admin/doctors/working-hours/$workingHourId";

  // Doctor Candidates

  static const String doctorCandidatesApi =
      "$server/api/admin/doctors/candidates";
  static String searchDoctorCandidates(String query) =>
      "$server/api/admin/doctors/candidates?search=$query";
  static const String inviteDoctor = "$server/api/admin/doctor-invitations";

  static String updateDoctorStatus(int doctorId) =>
      "$server/api/admin/doctors/$doctorId/status";

  // Services
  static const String catalogServices = "$server/api/admin/services/catalog";
  static const String centerServices = "$server/api/admin/centers/services";

  // ================= Admin Reports =================
  static const String appointmentsTrend =
      "https://medical.doctorme.site/api/admin/reports/appointments-trend?from=2025-08-20&to=2025-08-27";

  static String centerDetailed(String from, String to) =>
      "$server/api/admin/reports/center-detailed?from=$from&to=$to";

  //  Super Admin Endpoints
  static const String superAdminStatistics =
      "$server/superadmin/dashboard/statistics";
  static const pendingDoctors =
      "https://medical.doctorme.site/api/super-admin/doctors/pending";

  static String doctorCandidates(String search) =>
      "$server/admin/doctors/candidates?search=$search";

  static const String superAdminGetCenters = "$server/api/superadmin/centers";
  static const String superAdminToggleCenter = "$server/api/superadmin/centers";
  static String superAdminUpdateCenter(int id) =>
      "$server/api/superadmin/centers/$id";

  static String approveDoctor(int id) =>
      "https://medical.doctorme.site/api/super-admin/doctors/$id/approve";

  static String rejectDoctor(int id) =>
      "https://medical.doctorme.site/api/super-admin/doctors/$id/reject";

  static const String centerAdmins = "$server/superadmin/center-admins";
  static String centerAdminById(int id) =>
      "$server/api/superadmin/center-admins/$id";
  static String updateCenterAdmin(int id) =>
      "$server/api/superadmin/center-admins/$id";
  static String toggleCenterAdminStatus(int id) =>
      "$server/api/superadmin/center-admins/$id/toggle-status";
  static const String registerCenterAdmin =
      '$server/api/superadmin/register-center-admin';
  // Toggle user status endpoint
  static String toggleUserStatus(int userId) =>
      "$server/api/superadmin/users/$userId/toggle-status";

  // Assign user role endpoint
  static String assignUserRole(int userId) =>
      "$server/api/superadmin/users/$userId/assign-role";

  static const String superAdminLicenses = "$server/api/superadmin/licenses";
  static String updateLicenseStatus(int id) =>
      "$server/api/superadmin/licenses/$id/status";

  static const String users = "$server/api/superadmin/users";

  // Super Admin Reports
  static const String superAdminReports = "$server/api/superadmin/reports";
  static String superAdminReportById(int reportId) =>
      "$server/api/superadmin/reports/$reportId";
}
