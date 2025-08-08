import 'dart:convert';
import 'package:get/get.dart';
import 'package:medilink/api_link.dart';
import 'package:medilink/core/class/statusrequest.dart';
import 'package:medilink/data/datasourse/remot/PatientsData%20.dart';
import 'package:medilink/models/patient_model.dart';
import 'package:medilink/core/class/crud.dart';

class PatientsController extends GetxController {
  Crud crud = Crud();

  RxList<PatientModel> patients = <PatientModel>[].obs;
  StatusRequest statusRequest = StatusRequest.none;
  var isLoading = false.obs;

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

        statusRequest = StatusRequest.success;

        if (res['success'] == true) {
          patients.value =
              (res['data'] as List)
                  .map((e) => PatientModel.fromJson(e))
                  .toList();
          print("Patients List: ${patients.length}");
        } else {
          statusRequest = StatusRequest.failure;
        }
        update();
      },
    );
  }

  //===========================================================================
  Future<void> updatePatient(int id, Map<String, dynamic> data) async {
    print(" بدء تعديل المريض ID: $id");
    print(" البيانات المرسلة: $data");

    statusRequest = StatusRequest.loading;
    update();

    try {
      final response = await patientsData.updatePatient(id, data);

      if (response.statusCode == 200) {
        final res = jsonDecode(response.body);
        if (res['success'] == true) {
          print(" تم التعديل بنجاح: ${res['data']}");

          final updatedPatient = PatientModel.fromJson(res['data']);
          final index = patients.indexWhere((p) => p.id == id);
          if (index != -1) patients[index] = updatedPatient;

          Get.snackbar("نجاح", "تم تعديل بيانات المريض");
          Get.back();
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

  //===========================================================================
  Future<void> searchPatients(String query) async {
    statusRequest = StatusRequest.loading;
    update();

    var response = await crud.getData(AppLink.searchPatients(query));

    response.fold(
      (failure) {
        print("❌ Error: $failure");
        statusRequest = StatusRequest.serverfailure;
      },
      (res) {
        print("✅ Search Response: $res");
        if (res['success'] == true) {
          patients.value =
              (res['data'] as List)
                  .map((e) => PatientModel.fromJson(e))
                  .toList();
          statusRequest = StatusRequest.success;
        } else {
          statusRequest = StatusRequest.failure;
        }
      },
    );

    update();
  }

  //===========================================================================
  // ✅ دالة لإضافة مريض جديد محلياً بعد الإضافة من السيرفر
  Future<void> deletePatient(int id) async {
    statusRequest = StatusRequest.loading;
    update();

    final url = AppLink.deletePatient(id);
    final result = await crud.deleteData(url);

    result.fold(
      (failure) {
        Get.snackbar("خطأ", "فشل حذف المريض");
        statusRequest = StatusRequest.failure;
        update();
      },
      (res) {
        if (res['success'] == true) {
          patients.removeWhere((p) => p.id == id);
          Get.snackbar("نجاح", "تم حذف المريض بنجاح");
          statusRequest = StatusRequest.success;
          update();
        } else {
          Get.snackbar("خطأ", res['message'] ?? "فشل حذف المريض");
          statusRequest = StatusRequest.failure;
          update();
        }
      },
    );
  }
}
