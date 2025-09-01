import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:medilink/api_link.dart';

class SuperAdminDashboardController extends GetxController {
  var isLoading = true.obs;

  var centers = 0.obs;
  var doctors = 0.obs;
  var patients = 0.obs;
  var appointments = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardStatistics();
  }

  Future<void> fetchDashboardStatistics() async {
    try {
      isLoading.value = true;

      final response = await http.get(
        Uri.parse(
          "https://medical.doctorme.site/api/superadmin/dashboard/statistics",
        ),
        headers: {
          "Authorization": "Bearer ${AppLink.superAdminToken}",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body["success"] == true && body["data"] != null) {
          final data = body["data"];
          centers.value = data["centers"] ?? 0;
          doctors.value = data["doctors"] ?? 0;
          patients.value = data["patients"] ?? 0;
          appointments.value = data["appointments"] ?? 0;
        } else {
          print("Unexpected response format: $body");
        }
      } else {
        print("Request failed: ${response.body}");
      }
    } catch (e) {
      print("Error fetching statistics: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
