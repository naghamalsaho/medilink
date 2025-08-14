import 'package:get/get.dart';
import 'package:medilink/core/class/crud.dart';
import 'package:medilink/core/class/statusrequest.dart';
import 'package:medilink/core/functions/handlingdatacontroller.dart';
import 'package:medilink/data/datasourse/remot/PatientsData%20.dart';
import 'package:medilink/models/patient_model.dart';
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
        print(" Error: $failure");
        statusRequest = StatusRequest.serverfailure;
        update();
      },
      (res) {
        print("Response: $res");

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
    print(" Start patient adjustment ID: $id");
    print(" Data sent: $data");

    statusRequest = StatusRequest.loading;
    update();

    try {
      final response = await patientsData.updatePatient(id, data);

      if (response.statusCode == 200) {
        final res = jsonDecode(response.body);
        if (res['success'] == true) {
          print(" Modified successfully: ${res['data']}");

          final updatedPatient = PatientModel.fromJson(res['data']);
          final index = patients.indexWhere((p) => p.id == id);
          if (index != -1) patients[index] = updatedPatient;

          Get.snackbar("Success", "Patient's data has been modified");
          Get.back();
        } else {
          Get.snackbar("failure", res['message'] ?? "Unknown failure");
        }
      } else {
        Get.snackbar("error", "Status: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("error", "exception : $e");
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
        print(" Error: $failure");
        statusRequest = StatusRequest.serverfailure;
      },
      (res) {
        print(" Search Response: $res");
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

  void addPatientLocally(PatientModel patient) {
    patients.insert(0, patient);
  }
}