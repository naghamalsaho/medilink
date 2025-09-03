import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:medilink/api_link.dart';

class DoctorInviteController extends GetxController {
  var isLoading = false.obs;
  var candidatesList = [].obs;
  var invitedDoctors = <int, bool>{}.obs;

  final String baseUrl =
      "https://medical.doctorme.site/api/admin/doctors/candidates";

  // جلب قائمة المرشحين
  Future<void> fetchDoctorCandidates({String searchQuery = ""}) async {
    try {
      isLoading.value = true;

      final url =
          searchQuery.isNotEmpty ? "$baseUrl?search=$searchQuery" : baseUrl;

      print("🔵 FETCH DOCTORS URL: $url");

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${AppLink.token}',
          "Accept": "application/json",
        },
      );

      print("🔵 STATUS: ${response.statusCode}");
      print("🔵 BODY: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true && data['data'] != null) {
          candidatesList.assignAll(
            List<Map<String, dynamic>>.from(data['data']),
          );
          print("✅ Candidates fetched: ${candidatesList.length}");
        } else {
          candidatesList.clear();
          print("⚠️ No data field in response");
        }
      } else {
        candidatesList.clear();
        print("❌ Failed with status: ${response.statusCode}");
      }
    } catch (e) {
      candidatesList.clear();
      print("❌ Error fetching doctor candidates: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // دعوة الدكتور
  // دعوة الدكتور
  Future<bool> inviteDoctor(
    int userId, {
    String message = "نرحّب بانضمامك إلى مركزنا.",
  }) async {
    try {
      final response = await http.post(
        Uri.parse(AppLink.inviteDoctor),
        headers: {
          'Authorization': 'Bearer ${AppLink.token}',
          "Accept": "application/json",
          "Content-Type": "application/json", // 🟢 لازم JSON
        },
        body: jsonEncode({"doctor_user_id": userId, "message": message}),
      );

      print("🔵 INVITE STATUS: ${response.statusCode}");
      print("🔵 INVITE BODY: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        Get.snackbar(
          "✅ Success",
          data["message"] ?? "Doctor invited successfully",
        );
        return true;
      } else {
        Get.snackbar("❌ Error", "Failed to invite doctor");
        return false;
      }
    } catch (e) {
      Get.snackbar("❌ Error", e.toString());
      return false;
    }
  }
}
