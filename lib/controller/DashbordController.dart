import 'package:get/get.dart';
import 'package:medilink/core/class/statusrequest.dart';
import 'package:medilink/core/services/MyServices.dart';
import 'package:medilink/core/functions/handlingdatacontroller.dart';
import 'package:medilink/data/datasourse/remot/DashbordData.dart';

class DashboardController extends GetxController {
  final DashboardData dashboardData = DashboardData(Get.find());
  final MyServices myServices = Get.find();

  var pendingAppointments = 0.obs;
  var newFiles = 0.obs;
  var todaysAppointmentsCount = 0.obs;
  var totalPatients = 0.obs;

  var todaysAppointments = <dynamic>[].obs;

  var statusRequest = StatusRequest.none.obs;

  @override
  void onInit() {
    super.onInit();
    print("DashboardController initialized");
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    statusRequest.value = StatusRequest.loading;
    print("Fetching dashboard data...");
    update();

    String? token = myServices.box.read("token");
    if (token == null || token.isEmpty) {
      print("No token found!");
      statusRequest.value = StatusRequest.failure;
      update();
      return;
    }

    var responseCases = await dashboardData.getDashboardCases(token);

    responseCases.fold(
      (l) {
        
        print("Dashboard stats fetch failed with status: $l");
        statusRequest.value = l;
      },
      (r) async {
        
        print("Dashboard stats fetched: $r");
        if (r['success'] == true) {
          pendingAppointments.value = r['data']['pending_appointments'];
          newFiles.value = r['data']['new_files'];
          todaysAppointmentsCount.value = r['data']['todays_appointments'];
          totalPatients.value = r['data']['total_patients'];

          var responseAppointments = await dashboardData.getTodayAppointments(
            token,
          );

          responseAppointments.fold(
            (l2) {
              print("Today's appointments fetch failed: $l2");
              todaysAppointments.value = [];
            },
            (r2) {
              print("Today's appointments fetched: $r2");
              todaysAppointments.value = r2['data'] ?? [];
            },
          );

          statusRequest.value = StatusRequest.success;
        } else {
          statusRequest.value = StatusRequest.failure;
        }
      },
    );

    update();
  }
}