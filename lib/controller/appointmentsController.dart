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
  var ignoredRequests = <Map<String, dynamic>>[].obs;
  @override
  void onInit() {
    super.onInit();
    loadStats();
        loadRequests();
       loadToday();
        loadIgnored();
       
  }
Future<void> loadIgnored() async {
    print('[Controller] loading ignored requests...');
    final res = await _requestsSource.fetchIgnored();
    res.fold(
      (err) {
        print('[Controller] loadIgnored failed: $err');
        // اختياري: التعامل مع الـ status لو بدك
      },
      (list) {
        print('[Controller] loadIgnored success, items=${list.length}');
        ignoredRequests.assignAll(list);
      },
    );
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
Future<bool> createAppointment({
  required int doctorId,
  required int patientId,
  required DateTime date, // date يحتوي على التاريخ + الوقت
  required String apptStatus,
  required String attendanceStatus,
  String? notes,
}) async {
  status.value = StatusRequest.loading;

  // FORMAT required by backend: "Y-m-d H:i:s" (no T, no Z)
  final dateStr = DateFormat('yyyy-MM-dd HH:mm:ss').format(date.toLocal());
  print(' [Controller] createAppointment doctorId=$doctorId patientId=$patientId date=$dateStr');

  final res = await _dataSource.bookAppointment(
    doctorId: doctorId,
    patientId: patientId,
    appointmentDate: dateStr,
    status: apptStatus,
    attendanceStatus: attendanceStatus,
    notes: notes,
  );

  bool success = false;

  res.fold(
    (l) {
      status.value = l;
      print(' [Controller] createAppointment failed: $l');
      Get.snackbar('Error', 'Failed to create appointment');
      success = false;
    },
    (appt) {
      todayRequests.insert(0, appt);
      status.value = StatusRequest.success;
      Get.snackbar('Success', 'Appointment created');
      // تحديث القوائم
      loadStats();
      loadRequests();
      success = true;
    },
  );

  return success;
}
// داخل AppointmentsController
Future<bool> bookAppointmentMinimal({
  required int doctorId,
  required int patientId,
  required String requestedDate, // already formatted 'yyyy-MM-dd HH:mm:ss'
  String? notes,
}) async {
  status.value = StatusRequest.loading;
  print('[Controller] bookAppointmentMinimal doctorId=$doctorId patientId=$patientId requested_date=$requestedDate notes=$notes');

  final res = await _dataSource.bookAppointmentMinimal(
    doctorId: doctorId,
    patientId: patientId,
    requestedDate: requestedDate,
    notes: notes,
  );

  bool success = false;

  res.fold(
    (err) {
      status.value = err;
      print('[Controller] bookAppointmentMinimal failed: $err');
      Get.snackbar('Error', 'Failed to book appointment');
      success = false;
    },
    (data) {
      print('[Controller] bookAppointmentMinimal success: $data');
      status.value = StatusRequest.success;
      // تحديث القوائم
      loadStats();
      loadRequests();
      loadToday();
      Get.snackbar('Success', 'Appointment request created successfully');
      success = true;
    },
  );

  return success;
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
Future<void> markAttendance({
  required int appointmentId,
  required String attendanceStatus, // "present" or "absent"
}) async {
  print("[Controller] markAttendance id=$appointmentId status=$attendanceStatus");
  
  // استخدم status الكلاس
  status.value = StatusRequest.loading;

  final res = await _dataSource.updateAttendance(
    appointmentId: appointmentId,
    status: attendanceStatus,
  );

  res.fold(
    (err) {
      status.value = err;
      Get.snackbar("Error", "Attendance update failed");
    },
    (data) {
      status.value = StatusRequest.success;
      Get.snackbar("Success", "Attendance updated to $attendanceStatus");
      loadStats();
      loadToday();
      loadRequests();
    },
  );
}


}