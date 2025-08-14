import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:intl/intl.dart';
import 'package:medilink/core/class/crud.dart';
import 'package:medilink/core/class/statusrequest.dart';
import 'package:medilink/data/datasourse/remot/AppointmentDataSource.dart';
import 'package:medilink/models/appointment_model.dart';

class AppointmentsController extends GetxController {
  final _dataSource = AppointmentStatsDataSource(Get.find<Crud>());
  final _requestsSource  = AppointmentStatsDataSource(Get.find<Crud>());
  
 var appointments = <Map<String, dynamic>>[].obs;
  var status  = StatusRequest.none.obs;
  var stats   = Rxn<AppointmentStats>();
 var requests = <Map<String,dynamic>>[].obs;
 var todayAppts    = <Map<String,dynamic>>[].obs;
 var todayRequests= <AppointmentModel>[].obs;
  @override
  void onInit() {
    super.onInit();
    loadStats();
        loadRequests();
       loadToday();
       
  }

  Future<void> loadStats() async {
    status.value = StatusRequest.loading;
    final res = await _dataSource.fetchStats();
    res.fold(
      (err) => status.value = err,
      (s)   {
        stats.value   = s;
        status.value  = StatusRequest.success;
      },
    );
  }
  
  Future<void> loadRequests() async {
    
    final res = await _requestsSource.fetchAll();
    res.fold(
      (_) => null,
      (list) {
        requests.assignAll(list);
      },
    );
  }
  
 Future<void> loadToday() async {
  
  status.value = StatusRequest.loading;
  print('[Controller] loading today appointments...');
  final res = await _dataSource.fetchToday();
  res.fold(
    (err) {
      print('[Controller] loadToday failed: $err');
      status.value = err;
      todayAppts.clear();
    },
    (list) {
      print('[Controller] loadToday success, items=${list.length}');
      todayAppts.assignAll(list);
      status.value = StatusRequest.success;
    },
  );
}
  Future<void> createAppointment({
  required int doctorId,
  required int patientId, 
  required DateTime date,
  required String apptStatus,
  required String attendanceStatus,
  String? notes,
}) async {
  status.value = StatusRequest.loading;
  final dateStr = DateFormat('yyyy/MM/dd').format(date);

  print(' [Controller] createAppointment doctorId=$doctorId patientId=$patientId date=$dateStr');

  final res = await _dataSource.bookAppointment(
    doctorId: doctorId,
    patientId: patientId,
    appointmentDate: dateStr,
    status: apptStatus,
    attendanceStatus: attendanceStatus,
    notes: notes,
  );

  res.fold(
    (l) {
      status.value = l;
      print(' [Controller] createAppointment failed: $l');
      Get.snackbar('Error', 'Failed to create appointment');
    },
    (appt) {
      todayRequests.insert(0, appt);
      status.value = StatusRequest.success;
     // Get.back();
      Get.snackbar('Success', 'Appointment created');
    
      loadStats();
      loadRequests();
    },
  );
}

  var appointmentDetails = Rxn<Map<String, dynamic>>();

Future<void> loadAppointmentDetails(int id) async {
  //status.value = StatusRequest.loading;
  final res = await _dataSource.fetchAppointmentDetails(id);
  res.fold(
    (err) => status.value = err,
    (data) {
      appointmentDetails.value = data;
      status.value = StatusRequest.success;
    },
  );
}
Future<void> approve(int id) async {
  print('[Controller] start approve id=$id');
  status.value = StatusRequest.loading;
  final res = await _dataSource.approveRequest(id);
  res.fold(
    (err) {
      print(' [Controller] approve failed for id=$id  error=$err');
      status.value = err;
    },
    (_) {
      print(' [Controller] approve SUCCESS for id=$id');
      status.value = StatusRequest.success;
       print('===========================================================================================');
      loadStats();
      loadRequests();
      Get.snackbar('Approved', 'Request successfully approved');
    },
  );
}

Future<void> reject(int id) async {
  print(' [Controller] start reject id=$id');
  status.value = StatusRequest.loading;
  final res = await _dataSource.rejectRequest(id);
  res.fold(
    (err) {
      print(' [Controller] reject failed for id=$id  error=$err');
      status.value = err;
    },
    (_) {
      print('[Controller] reject SUCCESS for id=$id');
      status.value = StatusRequest.success;
      loadStats();
      loadRequests();
      Get.snackbar('Rejected', 'Request successfully rejected');
    },
  );
}
Future<void> updateAppointment({
  required int id,
  required int doctorId,
  String? appointmentDate,
  required String apptStatus,
  required String attendanceStatus,
  String? notes,
  int? patientId,
}) async {
  status.value = StatusRequest.loading;

  final res = await _dataSource.updateAppointment(
    id: id,
    doctorId: doctorId,
    appointmentDate: appointmentDate,
    status: apptStatus,
    attendanceStatus: attendanceStatus,
    notes: notes,
    patientId: patientId,
  );

  res.fold(
    (err) {
      status.value = err;
      Get.snackbar('Error', 'Update failed');
    },
    (data) {
      status.value = StatusRequest.success;
      
      loadRequests();
      loadStats();
      Get.snackbar('Done', 'Appointment updated successfully');
    },
  );
}


Future<void> removeAppointment(int id) async {
  status.value = StatusRequest.loading;

  final res = await _dataSource.deleteAppointment(id);

  res.fold(
    (err) {
      status.value = err;
      Get.snackbar('Error', 'Delete failed');
    },
    (data) {
      status.value = StatusRequest.success;
      loadRequests();
      loadStats();
      Get.snackbar('Done', 'Appointment deleted successfully');
    },
  );
}

}