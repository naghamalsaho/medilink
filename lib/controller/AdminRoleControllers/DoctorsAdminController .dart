import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart' as client;
import 'package:medilink/api_link.dart';

class AdminDoctorsController extends GetxController {
  var doctorsList = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchDoctors();
    super.onInit();
  }

  void fetchDoctors() async {
    try {
      isLoading.value = true;
      var response = await http.get(
        Uri.parse(AppLink.doctorsApi),
        headers: {'Authorization': 'Bearer ${AppLink.token}'},
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        doctorsList.value = List<Map<String, dynamic>>.from(data['data']);
      } else {
        Get.snackbar('Error', 'Failed to fetch doctors');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
  //====================================================================================

  Future<bool> unlinkDoctorFromCenter(int doctorId) async {
    final url = 'https://medical.doctorme.site/api/admin/doctors/$doctorId';
    try {
      final response = await client.delete(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${AppLink.token}', // استخدم AppLink.token
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
}
