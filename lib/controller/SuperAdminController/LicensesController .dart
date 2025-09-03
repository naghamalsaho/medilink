import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:medilink/api_link.dart';

class LicensesController extends GetxController {
  var licensesList = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;

  final String apiUrl = 'https://medical.doctorme.site/api/superadmin/licenses';
  final box = GetStorage(); // for storing and retrieving token

  @override
  void onInit() {
    fetchLicenses();
    super.onInit();
  }

  void fetchLicenses() async {
    isLoading.value = true;

    String? token = box.read('token');

    if (token == null) {
      Get.snackbar('Error', 'No token found, please login again');
      isLoading.value = false;
      return;
    }

    try {
      var response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        licensesList.value = List<Map<String, dynamic>>.from(jsonData['data']);
      } else {
        Get.snackbar('Error', 'Failed to load licenses');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateLicenseStatus(int licenseId, String newStatus) async {
    String? token = box.read('token'); // ✅ fix: get token from storage

    if (token == null) {
      Get.snackbar('Error', 'No token found, please login again');
      return;
    }

    try {
      var url = Uri.parse(AppLink.updateLicenseStatus(licenseId));
      var response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'status': newStatus}),
      );

      if (response.statusCode == 200) {
        var index = licensesList.indexWhere((l) => l['id'] == licenseId);
        if (index != -1) {
          licensesList[index]['status'] = newStatus;
          licensesList.refresh();
        }
        Get.snackbar("Success", "License status updated successfully");
      } else {
        Get.snackbar("Error", "Failed to update license status");
      }
    } catch (e) {
      Get.snackbar("Exception", e.toString());
    }
  }
}
