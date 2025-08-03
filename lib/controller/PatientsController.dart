import 'dart:convert';

import 'package:get/get.dart';
import 'package:medilink/api_link.dart';
import 'package:medilink/core/class/statusrequest.dart';
import 'package:medilink/data/datasourse/remot/PatientsData%20.dart';
import 'package:medilink/models/patient_model.dart';

class PatientsController extends GetxController {
  List<PatientModel> patients = [];
  StatusRequest statusRequest = StatusRequest.none;

  final PatientsData patientsData = PatientsData(Get.find());

  @override
  void onInit() {
    getPatients();
    super.onInit();
  }

  Future<void> getPatients() async {
    statusRequest = StatusRequest.loading;
    update();

    var response = await patientsData.getPatients();

    response.fold(
      (failure) {
        print("❌ Error: $failure");
        statusRequest = StatusRequest.serverfailure;
        update();
      },
      (res) {
        print("✅ Response: $res");
        // استبدل هذا السطر:
        // statusRequest = handlingData(res as Response);
        // بهذا:
        statusRequest = StatusRequest.success;

        if (res['success'] == true) {
          patients =
              (res['data'] as List)
                  .map((e) => PatientModel.fromJson(e))
                  .toList();
          print("Patients List: $patients");
        } else {
          statusRequest = StatusRequest.failure;
        }
        update();
        // 1. انقل دالة updatePatient خارج getPatients
      },
    );
  }

  Future<void> updatePatient(int id, Map<String, dynamic> data) async {
    final url = AppLink.updatePatient(id);

    print("🔵 بدء تعديل المريض ID: $id");
    print("📤 البيانات المرسلة: $data");

    statusRequest = StatusRequest.loading;
    update();

    try {
      final response = await patientsData.updatePatient(id, data);

      if (response.statusCode == 200) {
        final res = jsonDecode(response.body);
        if (res['success'] == true) {
          print("✅ تم التعديل بنجاح: ${res['data']}");

          // تحديث القائمة المحلية
          final updatedPatient = PatientModel.fromJson(res['data']);
          final index = patients.indexWhere((p) => p.id == id);
          if (index != -1) patients[index] = updatedPatient;

          Get.snackbar("نجاح", "تم تعديل بيانات المريض");
          update();
          Get.back(); // إغلاق نافذة التعديل
        } else {
          Get.snackbar("فشل", res['message'] ?? "فشل غير معروف");
        }
      } else {
        Get.snackbar("خطأ", "Status: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("خطأ", "حدث استثناء: $e");
    } finally {
      statusRequest = StatusRequest.success;
      update();
    }
  }
}
