import 'package:get/get.dart';
import '../models/doctor_model.dart';

class DoctorsController extends GetxController {
  var doctorsList =
      <Doctor>[
        Doctor(
          name: "د. سامي الأحمر",
          specialty: "طب عام",
          qualification: "بكالوريوس طب وجراحة ماجستير طب عام",
          email: "sami.almaa@dnic.com",
          phone: "05012345678",
          schedule: "الأس - الحسين - 8:00 ص - 4:00 م",
        ),
        Doctor(
          name: "د. ليلى حسن",
          specialty: "أمراض نساء وولادة",
          qualification: "كلام المقدمة في أجل تعليم العامل",
          email: "",
          phone: "",
          schedule: "",
        ),
      ].obs;

  void addDoctor(Doctor newDoctor) {
    doctorsList.add(newDoctor);
  }

  void deleteDoctor(int index) {
    doctorsList.removeAt(index);
  }
}
