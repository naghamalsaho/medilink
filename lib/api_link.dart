import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:medilink/core/services/MyServices.dart';

class AppLink {
  // ================= Base URLs =================
  static const String serverimage = "http://192.168.139.152:8000";
  static const String server =
      "https://cors-anywhere.herokuapp.com/https://medical.doctorme.site";

  // ================= Auth =================
  static const String logIn = "$server/api/login";

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

  // ================= Admin Endpoints =================
  static const String doctorsApi = '$server/api/admin/doctors';

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

  // ================= Super Admin Endpoints =================
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
  static const String toggleUserStatus = "$server/api/superadmin/users";
  static const String assignUserRole = "$server/api/superadmin/users";

  static const String superAdminLicenses = "$server/api/superadmin/licenses";
  static String updateLicenseStatus(int id) =>
      "$server/api/superadmin/licenses/$id/status";
}
