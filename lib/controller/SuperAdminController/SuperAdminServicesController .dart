import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:medilink/api_link.dart';

class SuperAdminServicesController extends GetxController {
  var servicesList = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    fetchServices();
  }

  Future<void> fetchServices() async {
    isLoading.value = true;
    String? token = box.read('token');
    if (token == null) {
      Get.snackbar('Error', 'No token found, please login again');
      isLoading.value = false;
      return;
    }
    try {
      var response = await http.get(
        Uri.parse(AppLink.superAdminServices),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        servicesList.value = List<Map<String, dynamic>>.from(jsonData['data']);
      } else {
        Get.snackbar('Error', 'Failed to load services');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createService(
    String name,
    String description,
    bool isActive,
  ) async {
    String? token = box.read('token');
    if (token == null) return;
    try {
      var response = await http.post(
        Uri.parse(AppLink.superAdminServices),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'description': description,
          'is_active': isActive,
        }),
      );
      if (response.statusCode == 200) {
        var data = json.decode(response.body)['data'];
        servicesList.add(Map<String, dynamic>.from(data));
        Get.snackbar('Success', 'Service created successfully');
      } else {
        Get.snackbar('Error', 'Failed to create service');
      }
    } catch (e) {
      Get.snackbar('Exception', e.toString());
    }
  }

  Future<void> updateService(
    int id,
    String name,
    String description,
    bool isActive,
  ) async {
    String? token = box.read('token');
    if (token == null) return;
    try {
      var response = await http.put(
        Uri.parse(AppLink.superAdminServiceById(id)),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'description': description,
          'is_active': isActive,
        }),
      );
      if (response.statusCode == 200) {
        var updated = json.decode(response.body)['data'];
        final index = servicesList.indexWhere((s) => s['id'] == id);
        if (index != -1) {
          servicesList[index] = Map<String, dynamic>.from(updated);
          servicesList.refresh();
        }
        Get.snackbar('Success', 'Service updated successfully');
      } else {
        Get.snackbar('Error', 'Failed to update service');
      }
    } catch (e) {
      Get.snackbar('Exception', e.toString());
    }
  }
}
