import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:medilink/api_link.dart';

class AdminSecretariesController extends GetxController {
  var secretariesList = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;
  var searchQuery = "".obs;
  var statusFilter = "all".obs;
  late int currentCenterId;

  @override
  void onInit() {
    currentCenterId = 1; // مثال: المركز الأول
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
    isLoading.value = true;

    try {
      if (body.containsKey("is_active") && body["is_active"] is bool) {
        body["is_active"] = body["is_active"] ? 1 : 0;
      }

      body['role'] = 'secretary';
      body['center_id'] = currentCenterId; // 🔹 رقم المركز الحالي

      final response = await http.post(
        Uri.parse(AppLink.addSecretary),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer ${AppLink.token}",
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        fetchSecretaries(); // 🔹 تحديث القائمة بعد الإضافة
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
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  List<Map<String, dynamic>> get filteredSecretaries {
    final query = searchQuery.value.toLowerCase();

    return secretariesList.where((sec) {
      final matchesSearch =
          sec['full_name'].toString().toLowerCase().contains(query) ||
          sec['email'].toString().toLowerCase().contains(query) ||
          sec['phone'].toString().toLowerCase().contains(query);

      final matchesStatus =
          (statusFilter.value == "all") ||
          (statusFilter.value == "active" &&
              (sec['is_active'] == 1 || sec['is_active'] == true)) ||
          (statusFilter.value == "inactive" &&
              (sec['is_active'] == 0 || sec['is_active'] == false));

      return matchesSearch && matchesStatus;
    }).toList();
  }
}
