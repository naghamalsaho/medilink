import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:medilink/api_link.dart';

class SuperAdminPendingDoctorsController extends GetxController {
  var pendingDoctors = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPendingDoctors();
  }

  Future<void> fetchPendingDoctors() async {
    try {
      isLoading(true);
      var response = await http.get(
        Uri.parse(AppLink.pendingDoctors),
        headers: {
          'Authorization': 'Bearer ${AppLink.superAdminToken}',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        pendingDoctors.value = List<Map<String, dynamic>>.from(body['data']);
      } else {
        pendingDoctors.clear();
      }
    } catch (e) {
      print("Error fetching pending doctors: $e");
      pendingDoctors.clear();
    } finally {
      isLoading(false);
    }
  }

  Future<void> approveDoctor(int doctorId) async {
    try {
      var response = await http.post(
        Uri.parse(
          "https://medical.doctorme.site/api/super-admin/doctors/$doctorId/approve",
        ),
        headers: {
          'Authorization': 'Bearer ${AppLink.superAdminToken}',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Doctor approved successfully");
        fetchPendingDoctors(); // تحديث القائمة
      } else {
        Get.snackbar("Error", "Failed to approve doctor");
      }
    } catch (e) {
      print("Error approving doctor: $e");
    }
  }

  Future<void> rejectDoctor(int doctorId) async {
    try {
      var response = await http.post(
        Uri.parse(
          "https://medical.doctorme.site/api/super-admin/doctors/$doctorId/reject",
        ),
        headers: {
          'Authorization': 'Bearer ${AppLink.superAdminToken}',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Doctor rejected successfully");
        fetchPendingDoctors();
      } else {
        Get.snackbar("Error", "Failed to reject doctor");
      }
    } catch (e) {
      print("Error rejecting doctor: $e");
    }
  }
}
