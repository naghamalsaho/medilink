import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:medilink/api_link.dart';

class DoctorInviteController extends GetxController {
  var isLoading = false.obs;
  var candidatesList = <Map<String, dynamic>>[].obs;
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

  Future<bool> inviteDoctor(
    Map<String, dynamic> doctor, { // نرسل doctor object كامل
    String message = "Welcome to join our center.",
  }) async {
    int userId = doctor["user_id"] ?? doctor["id"];

    try {
      final response = await http.post(
        Uri.parse(AppLink.inviteDoctor),
        headers: {
          'Authorization': 'Bearer ${AppLink.token}',
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"doctor_user_id": userId, "message": message}),
      );

      print("🔵 INVITE STATUS: ${response.statusCode}");
      print("🔵 INVITE BODY: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // 🟢 تحديث الحالة فورًا
        invitedDoctors[userId] = true;
        doctor["invitation_status"] =
            "pending"; // تحديث مباشرة الـ doctor object
        candidatesList.refresh(); // تحديث الـ UI فورًا

        // 🟢 إشعار من فوق
        Get.snackbar(
          "✅ Success",
          data["message"] ?? "Doctor invited successfully",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green.shade600,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          duration: const Duration(seconds: 3),
        );

        return true;
      } else {
        Get.snackbar(
          "❌ Error",
          "Failed to invite doctor",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.shade600,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        "❌ Error",
        e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
      return false;
    }
  }
}
