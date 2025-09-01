import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:medilink/api_link.dart';

class SuperAdminCentersController extends GetxController {
  var centersList = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCenters();
  }

  Future<void> fetchCenters() async {
    try {
      isLoading(true);
      var response = await http.get(
        Uri.parse(AppLink.superAdminGetCenters),
        headers: {
          'Authorization': 'Bearer ${AppLink.superAdminToken}',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        if (body['success'] == true && body['data'] != null) {
          centersList.value = List<Map<String, dynamic>>.from(body['data']);
        } else {
          centersList.value = [];
        }
      } else {
        centersList.value = [];
      }
    } catch (e) {
      print("Error fetching centers: $e");
      centersList.value = [];
    } finally {
      isLoading(false);
    }
  }

  Future<void> toggleCenterStatus(int centerId) async {
    try {
      var response = await http.put(
        Uri.parse('${AppLink.superAdminToggleCenter}/$centerId/toggle-status'),
        headers: {
          'Authorization': 'Bearer ${AppLink.superAdminToken}',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        if (body['success'] == true && body['data'] != null) {
          // عدل القيمة locally
          int index = centersList.indexWhere((c) => c['id'] == centerId);
          if (index != -1) {
            centersList[index]['is_active'] = body['data']['is_active'];
            centersList.refresh();
          }
        }
      } else {
        print("Error toggling status: ${response.body}");
      }
    } catch (e) {
      print("Error toggling center status: $e");
    }
  }

  //=======================
  Future<void> updateCenter(int centerId, String name, String location) async {
    try {
      var response = await http.put(
        Uri.parse('${AppLink.superAdminToggleCenter}/$centerId'),
        headers: {
          'Authorization': 'Bearer ${AppLink.superAdminToken}',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'name': name, 'location': location}),
      );

      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        if (body['success'] == true && body['data'] != null) {
          // عدل القائمة locally
          int index = centersList.indexWhere((c) => c['id'] == centerId);
          if (index != -1) {
            centersList[index] = body['data'];
            centersList.refresh();
          }
          Get.snackbar("نجاح ✅", "تم تعديل بيانات المركز بنجاح");
        }
      } else {
        print("Error updating center: ${response.body}");
        Get.snackbar("خطأ ❌", "فشل تعديل بيانات المركز");
      }
    } catch (e) {
      print("Error updating center: $e");
      Get.snackbar("خطأ ❌", "صار خطأ غير متوقع");
    }
  }

  void openEditDialog(Map<String, dynamic> center) {
    final nameController = TextEditingController(text: center['name']);
    final locationController = TextEditingController(text: center['location']);
    var isLoading = false.obs;

    Get.defaultDialog(
      title: "Edit Medical Center",
      titleStyle: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.teal,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      content: Obx(
        () => Container(
          width: 500,
          height: 320,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Name Field
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: TextField(
                  controller: nameController,
                  style: const TextStyle(fontSize: 18),
                  decoration: InputDecoration(
                    labelText: "Name",
                    labelStyle: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Location Field
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: TextField(
                  controller: locationController,
                  style: const TextStyle(fontSize: 18),
                  decoration: InputDecoration(
                    labelText: "Location",
                    labelStyle: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),

              // Save Button / Loader
              isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        isLoading.value = true;
                        await updateCenter(
                          center['id'],
                          nameController.text,
                          locationController.text,
                        );
                        isLoading.value = false;
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.teal,
                      ),
                      child: const Text("Save"),
                    ),
                  ),
            ],
          ),
        ),
      ),
      radius: 20,
      barrierDismissible: false,
      cancel: TextButton(
        onPressed: () => Get.back(),
        child: const Text("Cancel", style: TextStyle(fontSize: 16)),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType keyboard = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboard,
        decoration: InputDecoration(
          prefixText: "$label: ",
          prefixStyle: const TextStyle(fontSize: 16),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}
