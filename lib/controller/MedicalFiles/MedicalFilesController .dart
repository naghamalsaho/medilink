import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:medilink/api_link.dart';
import 'package:file_picker/file_picker.dart';

class MedicalFilesController extends GetxController {
  var files = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  final int patientId;

  MedicalFilesController(this.patientId);

  // جلب الملفات
  Future<void> fetchFiles() async {
    isLoading.value = true;
    try {
      final response = await http.get(
        Uri.parse(AppLink.medicalFiles(patientId)),
        headers: {
          "Authorization": "Bearer ${AppLink.token}",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        files.assignAll(List<Map<String, dynamic>>.from(data['data']));
      } else {
        files.clear();
      }
    } catch (e) {
      files.clear();
      print("Error fetching medical files: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // رفع ملف
  Future<void> uploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      final fileBytes = result.files.first.bytes;
      final fileName = result.files.first.name;

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(AppLink.uploadMedicalFile(patientId)),
      );
      request.headers["Authorization"] = "Bearer ${AppLink.token}";
      request.files.add(
        http.MultipartFile.fromBytes('file', fileBytes!, filename: fileName),
      );

      var response = await request.send();
      if (response.statusCode == 200) {
        fetchFiles();
        Get.snackbar(
          "✅ Success",
          "Medical file uploaded successfully",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green.withOpacity(0.85),
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          "❌ Error",
          "Failed to upload file",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.withOpacity(0.85),
          colorText: Colors.white,
        );
      }
    }
  }

  Future<void> deleteFile(int fileId) async {
    try {
      final response = await http.delete(
        Uri.parse(AppLink.deleteMedicalFile(patientId, fileId)), // 🟢 هنا
        headers: {
          "Authorization": "Bearer ${AppLink.token}",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        files.removeWhere((f) => f['id'] == fileId);
        Get.snackbar(
          "✅ Success",
          "File deleted successfully",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green.withOpacity(0.85),
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          "❌ Error",
          "Failed to delete file",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.withOpacity(0.85),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "❌ Error",
        e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.85),
        colorText: Colors.white,
      );
    }
  }
}
