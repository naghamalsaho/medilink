import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:medilink/api_link.dart';

class AdminSecretariesController extends GetxController {
  var secretariesList = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchSecretaries();
    super.onInit();
  }

  //================= Get all ==================
  void fetchSecretaries() async {
    try {
      isLoading.value = true;
      var response = await http.get(
        Uri.parse(AppLink.secretariesApi),
        headers: {'Authorization': 'Bearer ${AppLink.token}'},
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print("📥 API Response: ${response.body}");

        secretariesList.value = List<Map<String, dynamic>>.from(data['data']);
      } else {
        Get.snackbar('Error', 'Failed to fetch secretaries');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  //================= Delete ==================
  Future<void> deleteSecretary(int userId) async {
    final confirm = await Get.defaultDialog<bool>(
      title: "Confirm deletion",
      middleText: "Are you sure you want to delete this secretary?",
      textCancel: "Cancel",
      textConfirm: "Delete",
      onConfirm: () => Get.back(result: true),
      onCancel: () => Get.back(result: false),
    );

    if (confirm != true) return;

    try {
      isLoading.value = true;
      final response = await http.delete(
        Uri.parse(AppLink.deleteSecretary(userId)),
        headers: {
          'Authorization': 'Bearer ${AppLink.token}',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        secretariesList.removeWhere((sec) => sec['user_id'] == userId);

        Get.snackbar(
          'Success',
          'Secretary deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to delete secretary',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  //================= Update ==================
  Future<void> updateSecretary(int userId, Map<String, dynamic> body) async {
    try {
      isLoading.value = true;

      print("🔵 Update Secretary Called with userId: $userId and body: $body");

      if (userId == 0) {
        Get.snackbar(
          "Error",
          "Secretary ID is missing!",
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      // 🔑 تأكد أن is_active ينرسل كـ int
      if (body.containsKey("is_active")) {
        if (body["is_active"] is bool) {
          body["is_active"] = body["is_active"] ? 1 : 0;
        }
      }

      final response = await http.put(
        Uri.parse(AppLink.updateSecretary(userId)),
        headers: {
          'Authorization': 'Bearer ${AppLink.token}',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      print("🟡 Status code: ${response.statusCode}");
      print("🟡 Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // ✅ تحديث القائمة الداخلية
        final index = secretariesList.indexWhere(
          (sec) => sec['user_id'] == userId,
        );
        if (index != -1) {
          secretariesList[index] = Map<String, dynamic>.from(data['data']);
        }

        Get.snackbar(
          "Done",
          "Secretary updated successfully",
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          "Error",
          "Failed to update secretary",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print("🔥 Exception: $e");
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  //================= Add Secretary ==================
  Future<void> addSecretary(Map<String, dynamic> body) async {
    isLoading.value = true; // 🔹 بداية التحميل
    final url = Uri.parse(AppLink.addSecretary);

    try {
      if (body.containsKey("is_active") && body["is_active"] is bool) {
        body["is_active"] = body["is_active"] ? 1 : 0;
      }

      body['role'] = 'secretary';
      body['center_id'] = 1;

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer ${AppLink.token}",
        },
        body: jsonEncode(body),
      );

      print("🟢 Add response: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        secretariesList.add({
          "user_id": data['data']['user_id'],
          "full_name": body['full_name'],
          "email": body['email'],
          "phone": body['phone'],
          "shift": body['shift'],
          "is_active": body['is_active'],
        });

        Get.snackbar(
          "Success",
          "Secretary added successfully",
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          "Error",
          "Failed to add secretary",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print("🔥 Exception: $e");
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false; // 🔹 نهاية التحميل
    }
  }
}
