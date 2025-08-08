import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:medilink/api_link.dart';
import 'package:medilink/controller/PatientsController.dart';
import 'package:medilink/core/services/MyServices.dart';
import 'package:medilink/models/patient_model.dart';

class AddPatientController extends GetxController {
  // حقول تحكم النصوص
  var nameController = TextEditingController();
  var ageController = TextEditingController();
  var phoneController = TextEditingController();
  var emailController = TextEditingController();
  var addressController = TextEditingController();
  var gender = 'Male'.obs;
  var isLoading = false.obs;

  // دالة الإضافة
  Future<void> addPatient() async {
    if (nameController.text.isEmpty || ageController.text.isEmpty) {
      Get.snackbar('خطأ', 'الاسم والعمر مطلوبان');
      return;
    }

    isLoading.value = true;
    final box = Get.find<MyServices>().box;
    final token = box.read("token"); // ⚠️ مو AppLink.token
    var url = Uri.parse(AppLink.patients);
    final body = {
      "name": nameController.text,
      "age": int.tryParse(ageController.text) ?? 0,
      "gender": gender.value,
      "phone": phoneController.text,
      "email": emailController.text,
      "address": addressController.text,
      "status": "Active",
    };

    print("🔁 Sending request to: $url");
    print("📤 Request body: $body");

    try {
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      print("🔵 STATUS: ${response.statusCode}");
      print("🟢 BODY: ${response.body}");

      final res = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (res['success'] == true) {
          Get.back();
          Get.snackbar('نجاح', 'تمت إضافة المريض بنجاح');

          /// ✅ إنشاء PatientModel جديد مباشرة
          final patient = PatientModel(
            id: res['data']['user_id'],
            fullName: nameController.text,
            email: emailController.text,
            phone: phoneController.text,
            age: ageController.text,
            status: "Active",
          );

          /// ✅ إضافة للمصفوفة مباشرة بدون getPatients()
          final patientsController = Get.find<PatientsController>();
          patientsController.patients.insert(0, patient);
          patientsController.update();
        } else {
          Get.snackbar('خطأ', res['message'] ?? 'فشلت العملية');
        }
      } else {
        Get.snackbar('خطأ', res['message'] ?? 'فشلت الإضافة');
      }
    } catch (e) {
      print("❌ Exception: $e");
      Get.snackbar('استثناء', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
