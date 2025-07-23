import 'package:get/get.dart';
import 'package:medilink/models/patient_model.dart';

class PatientsController extends GetxController {
  List<PatientModel> patients = [];
  bool isLoading = true;

  @override
  void onInit() {
    fetchPatients();
    super.onInit();
  }

  void fetchPatients() async {
    await Future.delayed(Duration(seconds: 2)); // نحاكي وقت الانتظار

    // داتا تجريبية مؤقتة
    patients = [
      PatientModel(
        id: 1,
        name: "Ahmed Mohamed Ali",
        email: "ahmed@email.com",
        phone: "05012345678",
        age: "35",
        condition: "Diabetes",
        lastVisit: "2024-01-15",
        status: "Active",
      ),
      PatientModel(
        id: 2,
        name: "Fatima Saad",
        email: "fatima@email.com",
        phone: "05098765432",
        age: "28",
        condition: "Blood Pressure",
        lastVisit: "2024-01-20",
        status: "Active",
      ),
      PatientModel(
        id: 3,
        name: "Mohamed Khaled",
        email: "mohammed@email.com",
        phone: "0505555555",
        age: "42",
        condition: "Heart Disease",
        lastVisit: "2024-01-10",
        status: "Follow-up",
      ),
    ];

    isLoading = false;
    update(); // مهمة لتحديث الواجهة
  }
}
