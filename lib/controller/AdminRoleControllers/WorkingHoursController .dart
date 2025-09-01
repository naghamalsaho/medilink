import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:medilink/api_link.dart';

class WorkingHoursController extends GetxController {
  var dayOfWeek = ''.obs;
  var startTime = Rx<TimeOfDay?>(null);
  var endTime = Rx<TimeOfDay?>(null);
  var workingHours = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  Future<void> fetchWorkingHours(int doctorId) async {
    try {
      isLoading.value = true;
      workingHours.clear();

      final response = await http.get(
        Uri.parse(
          "${AppLink.server}/api/admin/doctors/$doctorId/working-hours",
        ),
        headers: {
          "Authorization": "Bearer ${AppLink.adminToken}",
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        workingHours.value = List<Map<String, dynamic>>.from(data['data']);
      } else {
        Get.snackbar("Error", "Failed to load working hours");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // 🔹 تحويل TimeOfDay لـ HH:mm
  String formatTimeOfDay(TimeOfDay tod) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    return DateFormat('HH:mm').format(dt);
  }

  // 🔹 إضافة ساعة عمل
  Future<void> addWorkingHour({
    required int doctorId,
    required String dayOfWeek,
    required String startTime,
    required String endTime,
  }) async {
    isLoading.value = true;
    try {
      final url = Uri.parse(
        "${AppLink.server}/api/admin/doctors/$doctorId/working-hours",
      );
      final body = {
        "day_of_week": dayOfWeek,
        "start_time": startTime,
        "end_time": endTime,
      };

      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer ${AppLink.adminToken}",
          "Content-Type": "application/json",
          'Accept': 'application/json',
        },
        body: jsonEncode(body),
      );

      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        await fetchWorkingHours(doctorId);

        Get.defaultDialog(
          title: "نجاح",
          middleText: data['message'] ?? "تمت الإضافة بنجاح",
          textConfirm: "تمام",
          onConfirm: () => Get.back(),
        );
      } else {
        Get.defaultDialog(
          title: "خطأ",
          middleText: data['message'] ?? "حدث خطأ أثناء الإضافة",
          textConfirm: "حسنًا",
          onConfirm: () => Get.back(),
        );
      }
    } catch (e) {
      Get.defaultDialog(
        title: "خطأ",
        middleText: "حدث خطأ في الاتصال: $e",
        textConfirm: "حسنًا",
        onConfirm: () => Get.back(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // 🔹 تعديل ساعة العمل
  Future<void> updateWorkingHour({
    required int workingHourId,
    required String dayOfWeek,
    required String startTime,
    required String endTime,
    required int doctorId, // عشان نرجع نحدث القائمة بعد التعديل
  }) async {
    isLoading.value = true;
    try {
      final url = Uri.parse(AppLink.updateWorkingHour(workingHourId));
      final body = {
        "day_of_week": dayOfWeek,
        "start_time": startTime,
        "end_time": endTime,
      };

      final response = await http.put(
        url,
        headers: {
          "Authorization": "Bearer ${AppLink.adminToken}",
          "Content-Type": "application/json",
          'Accept': 'application/json',
        },
        body: jsonEncode(body),
      );

      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        await fetchWorkingHours(doctorId);
        Get.defaultDialog(
          title: "نجاح",
          middleText: data['message'] ?? "تم التعديل بنجاح",
          textConfirm: "تمام",
          onConfirm: () => Get.back(),
        );
      } else {
        Get.defaultDialog(
          title: "خطأ",
          middleText: data['message'] ?? "حدث خطأ أثناء التعديل",
          textConfirm: "حسنًا",
          onConfirm: () => Get.back(),
        );
      }
    } catch (e) {
      Get.defaultDialog(
        title: "خطأ",
        middleText: "حدث خطأ في الاتصال: $e",
        textConfirm: "حسنًا",
        onConfirm: () => Get.back(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // 🔹 تابع حذف ساعة العمل
  Future<void> deleteWorkingHour(int workingHourId, int doctorId) async {
    isLoading.value = true;
    try {
      final url = Uri.parse(
        "${AppLink.server}/api/admin/doctors/working-hours/$workingHourId",
      );
      final response = await http.delete(
        url,
        headers: {
          "Authorization": "Bearer ${AppLink.adminToken}",
          "Accept": "application/json",
        },
      );

      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        await fetchWorkingHours(doctorId); // تحديث القائمة بعد الحذف
        Get.snackbar("نجاح", data['message'] ?? "تم حذف ساعة العمل");
      } else {
        Get.snackbar("خطأ", data['message'] ?? "حدث خطأ أثناء الحذف");
      }
    } catch (e) {
      Get.snackbar("خطأ", "حدث خطأ في الاتصال: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
