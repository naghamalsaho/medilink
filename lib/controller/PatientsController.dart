import 'package:get/get.dart';
import 'package:medilink/core/class/statusrequest.dart';
import 'package:medilink/core/functions/handlingdatacontroller.dart';
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
      },
    );
  }
}
