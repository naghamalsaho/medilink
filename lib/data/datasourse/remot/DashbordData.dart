import 'package:medilink/core/class/crud.dart';
import 'package:medilink/api_link.dart';

class DashboardData {
  Crud crud;
  DashboardData(this.crud);

  Future<dynamic> getDashboardCases(String token) async {
    print(" Calling API: ${AppLink.dashboard}");
    var response = await crud.getData(AppLink.dashboard);
    print(" Dashboard Response: $response");
    return response;
  }

  Future<dynamic> getTodayAppointments(String token) async {
    return await crud.getData(AppLink.todaysAppointments);
  }
}