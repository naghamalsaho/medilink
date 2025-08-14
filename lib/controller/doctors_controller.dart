import 'package:dartz/dartz.dart' ;
import 'package:get/get.dart';
import 'package:medilink/core/class/crud.dart';
import 'package:medilink/core/class/statusrequest.dart';
import 'package:medilink/data/datasourse/remot/DoctorDataSource%20.dart';
import '../models/doctor_model.dart';


class DoctorController extends GetxController {
  final _dataSource = DoctorDataSource(Get.find<Crud>());

  var status = StatusRequest.none.obs;
  var doctors = <DoctorModel>[].obs;
  var doctorAppointments = <Map<String, dynamic>>[].obs;
  var appointmentsStatus = StatusRequest.none.obs;
 var selectedDoctor = Rxn<DoctorModel>();
  @override
  void onInit() {
    super.onInit();
    loadDoctors();
  }

  Future<void> loadDoctors() async {
    status.value = StatusRequest.loading;
    final res = await _dataSource.fetchAll();
    res.fold(
      (err) => status.value = err,
      (list) {
        doctors.assignAll(list);
        status.value = StatusRequest.success;
      },
    );
  }

  Future<void> searchDoctors(String query) async {
    status.value = StatusRequest.loading;
    Either<StatusRequest, List<DoctorModel>> res;

    if (query.trim().isEmpty) {
      
      res = await _dataSource.fetchAll();
    } else {
      res = await _dataSource.searchDoctors(query);
    }

    res.fold(
      (err) => status.value = err,
      (list) {
        doctors.assignAll(list);
        status.value = StatusRequest.success;
      },
    );
  }
   Future<void> loadDoctorById(int id) async {
    status.value = StatusRequest.loading;
    final res = await _dataSource.fetchById(id);
    res.fold(
      (err) => status.value = err,
      (doc) {
        selectedDoctor.value = doc;
        status.value = StatusRequest.success;
      },
    );
  }
   Future<void> loadDoctorAppointments(int doctorId) async {
    appointmentsStatus.value = StatusRequest.loading;
    final res = await _dataSource.fetchAppointmentsForDoctor(doctorId);
    res.fold(
      (err) => appointmentsStatus.value = err,
      (list) {
        doctorAppointments.assignAll(list);
        appointmentsStatus.value = StatusRequest.success;
      },
    );
  }
}