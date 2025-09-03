import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:medilink/api_link.dart';

class CenterAdminsController extends GetxController {
  var isLoading = true.obs;
  var adminsList = <Map<String, dynamic>>[].obs;
  var selectedAdmin = <String, dynamic>{}.obs;
  var isLoadingAdmins = true.obs; // للقائمة
  var isLoadingDetails = false.obs; // لتفاصيل المدير

  Widget buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }

  // ================= Fetch admins =================

  Future<void> fetchCenterAdmins() async {
    try {
      isLoading(true);
      print("💡 Fetching center admins...");

      final response = await http.get(
        Uri.parse("https://medical.doctorme.site/api/superadmin/center-admins"),
        headers: {
          "Authorization": "Bearer ${AppLink.token}",
          "Accept": "application/json",
        },
      );

      print("💡 Status code: ${response.statusCode}");
      print("💡 Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("💡 Parsed data: $data");

        if (data['data'] != null && data['data'] is List) {
          adminsList.value = List<Map<String, dynamic>>.from(data['data']);
          print("💡 Admins list length: ${adminsList.length}");
        } else {
          adminsList.clear();
          print("⚠️ Data['data'] is null or not a list");
        }
      } else {
        adminsList.clear();
        print("⚠️ Failed to fetch admins, status code: ${response.statusCode}");
        Get.snackbar("Error", "فشل بجلب مدراء المراكز");
      }
    } catch (e) {
      adminsList.clear();
      print("❌ Exception caught: $e");
      Get.snackbar("Error", "حدث خطأ: $e");
    } finally {
      isLoading(false);
    }
  }

  // ================= Fetch admin by id =================

  Future<void> fetchAdminById(int id) async {
    try {
      isLoadingDetails(true);

      final url = AppLink.centerAdminById(id); // الرابط الصحيح
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer ${AppLink.token}",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["success"] == true) {
          final admin = data["data"];
          selectedAdmin.value = admin; // خزّن البيانات في المتغير

          // عرض الديالوغ
          Get.dialog(
            Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                width: 600,
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Admin Details",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      buildDetailRow("Name", admin['full_name']),
                      buildDetailRow("Email", admin['email']),
                      buildDetailRow("Phone", admin['phone']),
                      buildDetailRow(
                        "Active",
                        admin['is_active'] ? "Yes" : "No",
                      ),
                      buildDetailRow("IP Address", admin['ip_address'] ?? '-'),
                      buildDetailRow("Created At", admin['created_at'] ?? '-'),
                      buildDetailRow("Updated At", admin['updated_at'] ?? '-'),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => Get.back(),
                          child: const Text("Close"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else {
          Get.snackbar("Error", "Failed to fetch admin data");
        }
      } else {
        Get.snackbar("Error", "Admin not found or wrong URL");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    } finally {
      isLoadingDetails(false);
    }
  } // Toggle status

  // ================= Update admin =================
  Future<void> updateAdmin(
    int id,
    String fullName,
    String email,
    String phone,
  ) async {
    try {
      isLoadingDetails(true);

      final url = AppLink.updateCenterAdmin(id);
      final body = jsonEncode({
        "full_name": fullName,
        "email": email,
        "phone": phone,
      });

      final response = await http.put(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer ${AppLink.token}",
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["success"] == true) {
          // حدث القائمة فورًا
          await fetchCenterAdmins();
          Get.back(); // اقفل الديالوغ
          Get.snackbar("Success", "Admin updated successfully");
        } else {
          Get.snackbar("Error", data["message"] ?? "Failed to update admin");
        }
      } else {
        Get.snackbar("Error", "Admin not found or wrong URL");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    } finally {
      isLoadingDetails(false);
    }
  }

  // ================= Show edit dialog =================
  void showEditAdminDialog(Map<String, dynamic> admin) {
    final fullNameController = TextEditingController(text: admin['full_name']);
    final emailController = TextEditingController(text: admin['email']);
    final phoneController = TextEditingController(text: admin['phone']);

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: 600,
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Edit Admin",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: fullNameController,
                  decoration: const InputDecoration(labelText: "Name"),
                ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: "Email"),
                ),
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: "Phone"),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text("Cancel"),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        updateAdmin(
                          admin['id'],
                          fullNameController.text,
                          emailController.text,
                          phoneController.text,
                        );
                      },
                      child: const Text("Save"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= Toggle admin status =================
  void confirmToggleAdminStatus(Map<String, dynamic> admin) {
    bool isActive = admin["is_active"] ?? true;

    Get.dialog(
      AlertDialog(
        title: Text(isActive ? "Deactivate Admin?" : "Activate Admin?"),
        content: Text(
          isActive
              ? "هل أنت متأكد من تعطيل هذا المدير؟"
              : "هل أنت متأكد من تفعيل هذا المدير؟",
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              Get.back(); // اقفل الديالوغ
              await toggleAdminStatus(admin["id"]); // فعل التغيير
            },
            child: const Text("Confirm"),
          ),
        ],
      ),
    );
  }

  //=============================
  Future<void> toggleAdminStatus(int id) async {
    try {
      final response = await http.put(
        Uri.parse(AppLink.toggleCenterAdminStatus(id)),
        headers: {
          "Authorization": "Bearer ${AppLink.token}",
          "Accept": "application/json",
        },
      );

      print("💡 Toggle status code: ${response.statusCode}");
      print("💡 Toggle response: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        int index = adminsList.indexWhere((a) => a["id"] == id);
        if (index != -1) {
          adminsList[index]["is_active"] = data["data"]["is_active"];
          adminsList.refresh();
        }
        Get.snackbar("Success", data["message"] ?? "Admin status toggled.");
      } else {
        Get.snackbar("Error", "فشل بتغيير الحالة (${response.statusCode})");
      }
    } catch (e) {
      Get.snackbar("Error", "حدث خطأ: $e");
    }
  }

  //=============================
  Future<void> registerCenterAdmin({
    required String fullName,
    required String email,
    required String password,
    required String centerName,
    required String centerLocation,
    required String phone,
    required String issuedBy,
    required String issueDate,
    required String amount, // أضفنا المبلغ
    Uint8List? licenseFileBytes, // للويب
    String? licenseFileName, // اسم الملف
  }) async {
    try {
      isLoading.value = true;

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(AppLink.registerCenterAdmin),
      );

      request.headers['Authorization'] = "Bearer ${AppLink.token}";
      request.headers['Accept'] = 'application/json';

      // الحقول
      request.fields['full_name'] = fullName;
      request.fields['email'] = email;
      request.fields['password'] = password;
      request.fields['center_name'] = centerName;
      request.fields['center_location'] = centerLocation;
      request.fields['phone'] = phone;
      request.fields['issued_by'] = issuedBy;
      request.fields['issue_date'] = issueDate;
      request.fields['amount'] = amount; // 💡 ضفناها هون

      // الملف (إذا موجود)
      if (licenseFileBytes != null && licenseFileName != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'license_file',
            licenseFileBytes,
            filename: licenseFileName,
          ),
        );
      }

      var response = await request.send();
      var responseBody = await http.Response.fromStream(response);

      print("🔵 Register status: ${response.statusCode}");
      print("🔵 Register body: ${responseBody.body}");

      var data = json.decode(responseBody.body);

      if (response.statusCode == 201 && data["success"] == true) {
        Get.snackbar("Success", "Center admin registered successfully");
        fetchCenterAdmins();
      } else {
        Get.snackbar(
          "Error",
          data["message"] ?? "Failed to register center admin",
        );
      }
    } catch (e) {
      Get.snackbar("Error", "Exception: $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchCenterAdmins();
  }
}
