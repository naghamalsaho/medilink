import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart' as client;
import 'package:medilink/api_link.dart';

class AdminDoctorsController extends GetxController {
  var doctorsList = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;
  var filteredDoctorsList = <Map<String, dynamic>>[].obs; // القائمة المعروضة
  var statusFilter = 'all'.obs; // <- القيمة الافتراضية
  var searchQuery = "".obs;
  var updatingStatus = <int>{}.obs; // IDs للأطباء اللي عم نحدّث حالتهم

  @override
  void onInit() {
    fetchDoctors();
    super.onInit();
  }

  void fetchDoctors() async {
    try {
      isLoading.value = true;
      final url = "https://medical.doctorme.site/api/admin/doctors";
      print("🔵 FETCH DOCTORS URL: $url");

      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${AppLink.token}',
          'Accept': 'application/json',
        },
      );

      print("🔵 Doctors API Status: ${response.statusCode}");
      print("🔵 Doctors API Body: ${response.body}");

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          doctorsList.value = List<Map<String, dynamic>>.from(data['data']);
          filteredDoctorsList.value = doctorsList; // عرض الكل بعد التحميل
          print(
            "✅ Doctors fetched successfully: ${doctorsList.length} doctors",
          );
        } else {
          print("❌ Doctors data not found or success false");
        }
      } else if (response.statusCode == 401) {
        print("❌ Unauthenticated! Check the token");
        Get.snackbar("Error", "Unauthenticated. Please check your token.");
      } else {
        print("❌ Failed to fetch doctors. Status: ${response.statusCode}");
        Get.snackbar(
          "Error",
          "Failed to fetch doctors. Status: ${response.statusCode}",
        );
      }
    } catch (e) {
      print("❌ Exception fetching doctors: $e");
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  //============================================================================
  void filterDoctors(String query, {String? statusFilter}) {
    final lowerQuery = query.toLowerCase().trim();

    // نعمل نسخة جديدة للقائمة المعروضة
    final filtered =
        doctorsList.where((doctor) {
          final user = doctor['user'] ?? {};
          final fullName = (user['full_name'] ?? '').toString().toLowerCase();
          final email = (user['email'] ?? '').toString().toLowerCase();
          final phone = (user['phone'] ?? '').toString().toLowerCase();

          final matchesQuery =
              lowerQuery.isEmpty ||
              fullName.contains(lowerQuery) ||
              email.contains(lowerQuery) ||
              phone.contains(lowerQuery);

          final isActive = (doctor['is_active'] ?? false) == true;
          final matchesStatus =
              statusFilter == null || // all
              (statusFilter == "active" && isActive) ||
              (statusFilter == "inactive" && !isActive);

          return matchesQuery && matchesStatus;
        }).toList();

    filteredDoctorsList.value = filtered;
  }
  //====================================================================================

  Future<bool> unlinkDoctorFromCenter(int doctorId) async {
    final url = 'https://medical.doctorme.site/api/admin/doctors/$doctorId';
    try {
      final response = await client.delete(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${AppLink.token}',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        print('Error deleting doctor: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception deleting doctor: $e');
      return false;
    }
  }
  //========================================================

  // Future<bool> updateDoctorStatus(int doctorId, bool isActive) async {
  //   final url = Uri.parse(
  //     "https://medical.doctorme.site/api/admin/doctors/$doctorId",
  //   );
  //   try {
  //     final response = await http.put(
  //       url,
  //       headers: {
  //         "Accept": "application/json",
  //         "Authorization":
  //             "Bearer uj8b7iZ164ZSMxiyQmPnW04odaij0gNCxj8sjr1kf01f0552",
  //       },
  //       body: {"is_active": isActive ? "1" : "0"},
  //     );

  //     if (response.statusCode == 200) {
  //       return true;
  //     } else {
  //       print("Failed: ${response.body}");
  //       return false;
  //     }
  //   } catch (e) {
  //     print("Error: $e");
  //     return false;
  //   }
  // }

  //=====================================================
  //=====================================================
  Future<bool> setDoctorActiveStatus(int doctorId, bool isActive) async {
    try {
      updatingStatus.add(doctorId);
      final res = await http.put(
        Uri.parse(
          "https://medical.doctorme.site/api/admin/doctors/$doctorId/status",
        ),
        headers: {
          'Authorization': 'Bearer ${AppLink.token}',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"is_active": isActive}),
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final updated = data['data']['is_active'];

        final idx = doctorsList.indexWhere((d) => d['id'] == doctorId);
        if (idx != -1) {
          doctorsList[idx]['is_active'] = updated;
          doctorsList.refresh();
        }

        // نعيد تطبيق الفلترة الحالية بعد تحديث الحالة
        filterDoctors(
          searchQuery.value,
          statusFilter: statusFilter.value == "all" ? null : statusFilter.value,
        );

        return true;
      }
      return false;
    } finally {
      updatingStatus.remove(doctorId);
    }
  }
}
