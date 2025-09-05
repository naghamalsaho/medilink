import 'package:get/get.dart';
import 'package:medilink/api_link.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// ================= Controller =================
class AdminDashboardController extends GetxController {
  var isLoading = true.obs;
  var dashboardData = Rx<DashboardData?>(null);
  var token = AppLink.token;

  @override
  void onInit() {
    super.onInit();
    fetchDashboard();
  }

  Future<void> fetchDashboard() async {
    try {
      isLoading.value = true;
      var response = await http.get(
        Uri.parse(AppLink.adminDashboard),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        dashboardData.value = DashboardData.fromJson(jsonData["data"]);
      } else {
        print("Error fetching dashboard: ${response.body}");
      }
    } catch (e) {
      print("Exception: $e");
    } finally {
      isLoading.value = false;
    }
  }
}

// ================= Data Models =================
class DashboardData {
  final Cards cards;
  final CenterStatus centerStatus;
  final TodaySummary todaySummary;
  final List<ChartData> chartLast7;

  DashboardData({
    required this.cards,
    required this.centerStatus,
    required this.todaySummary,
    required this.chartLast7,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      cards: Cards.fromJson(json["cards"]),
      centerStatus: CenterStatus.fromJson(json["center_status"]),
      todaySummary: TodaySummary.fromJson(json["today_summary"]),
      chartLast7: List<ChartData>.from(
        json["chart_last7"].map((x) => ChartData.fromJson(x)),
      ),
    );
  }
}

class Cards {
  final int totalAppointments;
  final int activeSecretaries;
  final int totalDoctors;
  final int totalPatients;

  Cards({
    required this.totalAppointments,
    required this.activeSecretaries,
    required this.totalDoctors,
    required this.totalPatients,
  });

  factory Cards.fromJson(Map<String, dynamic> json) => Cards(
    totalAppointments: json["total_appointments"],
    activeSecretaries: json["active_secretaries"],
    totalDoctors: json["total_doctors"],
    totalPatients: json["total_patients"],
  );
}

class CenterStatus {
  final double occupancyRate;
  final double patientSatisfaction;
  final double generalPerformance;

  CenterStatus({
    required this.occupancyRate,
    required this.patientSatisfaction,
    required this.generalPerformance,
  });

  factory CenterStatus.fromJson(Map<String, dynamic> json) => CenterStatus(
    occupancyRate: (json["occupancy_rate"] ?? 0).toDouble(),
    patientSatisfaction: (json["patient_satisfaction"] ?? 0).toDouble() / 100,
    generalPerformance: (json["general_performance"] ?? 0).toDouble() / 100,
  );
}

class TodaySummary {
  final int newAppointments;
  final int completedToday;
  final int pendingToday;

  TodaySummary({
    required this.newAppointments,
    required this.completedToday,
    required this.pendingToday,
  });

  factory TodaySummary.fromJson(Map<String, dynamic> json) => TodaySummary(
    newAppointments: json["new_appointments"],
    completedToday: json["completed_today"],
    pendingToday: json["pending_today"],
  );
}

class ChartData {
  final String date;
  final int newRequests;
  final int completed;

  ChartData({
    required this.date,
    required this.newRequests,
    required this.completed,
  });

  factory ChartData.fromJson(Map<String, dynamic> json) => ChartData(
    date: json["date"],
    newRequests: json["new_requests"],
    completed: json["completed"],
  );
}
