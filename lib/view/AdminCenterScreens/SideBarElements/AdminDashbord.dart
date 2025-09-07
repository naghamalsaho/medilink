import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink/controller/AdminRoleControllers/AdminDashboardController%20.dart';
import 'package:medilink/view/AdminCenterScreens/AdminDashbord/WelcomeBanner.dart';
import 'package:medilink/view/widget/dashbord/StatCard%20.dart';
import 'package:fl_chart/fl_chart.dart';

class AdminDashbord extends StatelessWidget {
  AdminDashbord({super.key});
  final AdminDashboardController controller = Get.put(
    AdminDashboardController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AdminWelcomeBanner(),
            const SizedBox(height: 20),

            // ================= Stats Cards =================
            Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              var data = controller.dashboardData.value;
              if (data == null) {
                return const Center(child: Text("No data available"));
              }

              return Center(
                child: Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  children: [
                    StatsCard(
                      title: "Total Appointments",
                      value: data.cards.totalAppointments.toString(),
                      badge: "",
                      icon: Icons.access_time,
                      color: Colors.blue,
                      token: '',
                    ),
                    StatsCard(
                      title: "Active Secretaries",
                      value: data.cards.activeSecretaries.toString(),
                      badge: "",
                      icon: Icons.description_outlined,
                      color: const Color(0xFF1E7F5C),
                      token: '',
                    ),
                    StatsCard(
                      title: "Total Doctors",
                      value: data.cards.totalDoctors.toString(),
                      badge: "",
                      icon: Icons.calendar_today_outlined,
                      color: Colors.green,
                      token: '',
                    ),
                    StatsCard(
                      title: "Total Patients",
                      value: data.cards.totalPatients.toString(),
                      badge: "",
                      icon: Icons.groups_outlined,
                      color: Colors.blue,
                      token: '',
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 30),

            // ================= Center Status & Today Summary =================
            Obx(() {
              if (controller.isLoading.value) return const SizedBox();

              var data = controller.dashboardData.value;
              if (data == null) return const SizedBox();

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: CenterStatusWidget(centerStatus: data.centerStatus),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 2,
                    child: TodaySummaryWidget(todaySummary: data.todaySummary),
                  ),
                ],
              );
            }),

            const SizedBox(height: 30),

            // ================= Chart Last 7 Days =================
            Obx(() {
              if (controller.isLoading.value) return const SizedBox();

              var data = controller.dashboardData.value;
              if (data == null || data.chartLast7.isEmpty) {
                return const Center(child: Text("No chart data available"));
              }

              var chartData = data.chartLast7;
              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        "Last 7 Days Summary",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),

                      SizedBox(
                        height: 200,
                        child: LineChart(
                          LineChartData(
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 40,
                                ),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  interval: 1,
                                  getTitlesWidget: (value, meta) {
                                    int index = value.toInt();
                                    if (index < 0 || index >= chartData.length)
                                      return const Text('');
                                    return Text(
                                      chartData[index].date.split("-").last,
                                      style: const TextStyle(fontSize: 10),
                                    );
                                  },
                                ),
                              ),
                            ),
                            gridData: FlGridData(show: true),
                            borderData: FlBorderData(show: true),
                            lineBarsData: [
                              LineChartBarData(
                                spots: List.generate(
                                  chartData.length,
                                  (i) => FlSpot(
                                    i.toDouble(),
                                    chartData[i].newRequests.toDouble(),
                                  ),
                                ),
                                isCurved: true,
                                color: Colors.blue,
                                barWidth: 3,
                                belowBarData: BarAreaData(show: false),
                              ),
                              LineChartBarData(
                                spots: List.generate(
                                  chartData.length,
                                  (i) => FlSpot(
                                    i.toDouble(),
                                    chartData[i].completed.toDouble(),
                                  ),
                                ),
                                isCurved: true,
                                color: Colors.green,
                                barWidth: 3,
                                belowBarData: BarAreaData(show: false),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // 🔹 Legend
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          LegendItem(
                            color: Colors.blue,
                            text: "New Appointments",
                          ),
                          SizedBox(width: 20),
                          LegendItem(color: Colors.green, text: "Completed"),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

// ================= Legend Widget =================
class LegendItem extends StatelessWidget {
  final Color color;
  final String text;
  const LegendItem({super.key, required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 16, height: 16, color: color),
        const SizedBox(width: 4),
        Text(text),
      ],
    );
  }
}

// ================= Center Status =================
class CenterStatusWidget extends StatelessWidget {
  final CenterStatus centerStatus;
  const CenterStatusWidget({super.key, required this.centerStatus});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Center Status",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Row of circular indicators with spacing
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCircularIndicator(
                  "Occupancy Rate",
                  centerStatus.occupancyRate,
                  Colors.green,
                ),
                _buildCircularIndicator(
                  "Patient Satisfaction",
                  centerStatus.patientSatisfaction,
                  Colors.blue,
                ),
                _buildCircularIndicator(
                  "General Performance",
                  centerStatus.generalPerformance,
                  Colors.purple,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircularIndicator(String title, double value, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 80,
          height: 80,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: value,
                color: color,
                backgroundColor: Colors.grey.shade300,
                strokeWidth: 8,
              ),
              Center(
                child: Text(
                  "${(value * 100).toInt()}%",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

// ================= Today Summary =================
class TodaySummaryWidget extends StatelessWidget {
  final TodaySummary todaySummary;
  const TodaySummaryWidget({super.key, required this.todaySummary});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Today Summary",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.add_circle_outline, color: Colors.blue),
              title: const Text("New Appointments"),
              trailing: Text(
                todaySummary.newAppointments.toString(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.check_circle_outline,
                color: Colors.green,
              ),
              title: const Text("Completed Appointments"),
              trailing: Text(
                todaySummary.completedToday.toString(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.cancel_outlined, color: Colors.red),
              title: const Text("Pending Appointments"),
              trailing: Text(
                todaySummary.pendingToday.toString(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
