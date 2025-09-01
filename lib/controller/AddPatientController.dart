import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:medilink/api_link.dart';
import 'package:medilink/controller/PatientsController.dart';
import 'package:medilink/core/class/statusrequest.dart';
import 'package:medilink/core/services/MyServices.dart';
import 'package:medilink/models/patient_model.dart';

class AddPatientController extends GetxController {
  var nameController = TextEditingController();
  var birthDateController = TextEditingController();
  var phoneController = TextEditingController();
  var emailController = TextEditingController();
  var addressController = TextEditingController();

  var gender = 'Male'.obs;
  var isLoading = false.obs;
  late int centerId;

  late String token;
  StatusRequest statusRequest = StatusRequest.none;

  @override
  void onInit() {
    super.onInit();
    token = Get.find<MyServices>().sharedPreferences.getString("token") ?? "";
    centerId =
        Get.find<MyServices>().sharedPreferences.getInt("center_id") ?? 1;
  }

  Future<void> addPatient() async {
    isLoading.value = true;
    statusRequest = StatusRequest.loading;
    update();

    var headers = {
      'Authorization':
          'Bearer uj8b7iZ164ZSMxiyQmPnW04odaij0gNCxj8sjr1kf01f0552',
      'Accept': 'application/json',
      'Content-Type': 'multipart/form-data',
    };

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://medical.doctorme.site/api/secretary/patients'),
    );

    request.headers.addAll(headers);

    request.fields['full_name'] = nameController.text;
    request.fields['email'] = emailController.text;
    request.fields['phone'] = phoneController.text;
    request.fields['birthdate'] = birthDateController.text;
    request.fields['gender'] = gender.value.toLowerCase();
    request.fields['address'] = addressController.text;
    request.fields['center_id'] = centerId.toString(); // ⚠️ مهم جدًا

    try {
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      print('Status code: ${response.statusCode}');
      print('Response body: $responseBody');

      var jsonData = jsonDecode(responseBody);

      if (response.statusCode == 201 && jsonData['success'] == true) {
        Get.snackbar(
          'success',
          jsonData['message'] ?? 'Patient added successfully',
        );
        statusRequest = StatusRequest.success;

        final patientsController = Get.find<PatientsController>();
        await patientsController.getPatients();

        Get.back();
      } else {
        Get.snackbar('error', jsonData['message'] ?? 'Failed to add');
        statusRequest = StatusRequest.failure;
      }
    } catch (e) {
      print('Error during addPatient request: $e');
      Get.snackbar('Error', 'An error occurred while sending data');
      statusRequest = StatusRequest.failure;
    } finally {
      isLoading.value = false;
      update();
    }
  }
}
