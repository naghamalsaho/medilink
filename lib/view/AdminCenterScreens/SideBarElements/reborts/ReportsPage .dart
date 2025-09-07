import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:medilink/controller/ServicesControllers.dart/Reborts/ReportsController%20.dart';

class ReportsPage extends StatefulWidget {
  ReportsPage({Key? key}) : super(key: key);

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  final ReportsController controller = Get.put(ReportsController());
  DateTimeRange? selectedRange;
  Future<void> pickDateRange() async {
    DateTimeRange? result = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2024, 1, 1),
      lastDate: DateTime(2030, 12, 31),
      initialDateRange:
          selectedRange ??
          DateTimeRange(
            start: DateTime.now().subtract(const Duration(days: 7)),
            end: DateTime.now(),
          ),
    );

    if (result != null) {
      setState(() => selectedRange = result);
      // 🔹 هون بتبعت API call مع selectedRange.start و selectedRange.end
      print("Start: ${selectedRange!.start}, End: ${selectedRange!.end}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Export button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Center Reports',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: controller.exportPDF,
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text('Export PDF'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal[300],
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    textStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Date Range Picker + Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Appointments Trend',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    DateTimeRange? picked = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime(2023),
                      lastDate: DateTime.now(),
                      initialDateRange: DateTimeRange(
                        start: controller.startDate.value,
                        end: controller.endDate.value,
                      ),
                    );
                    if (picked != null) {
                      controller.updateDateRange(picked.start, picked.end);
                    }
                  },
                  icon: const Icon(Icons.date_range),
                  label: const Text("Select Date Range"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal[300],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            SizedBox(
              height: 350,
              width: double.infinity,
              child: RepaintBoundary(
                key: controller.chartKey,
                child: appointmentsChart(),
              ),
            ),
            const SizedBox(height: 30),

            // Summary Cards
            const Text(
              'Appointments Summary',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  cardItem(
                    'Total',
                    controller.summary.value.total,
                    Colors.blue[100]!,
                  ),
                  cardItem(
                    'Completed',
                    controller.summary.value.completed,
                    Colors.green[100]!,
                  ),
                  cardItem(
                    'Pending',
                    controller.summary.value.pending,
                    Colors.orange[100]!,
                  ),
                  cardItem(
                    'Approved',
                    controller.summary.value.approved,
                    Colors.purple[100]!,
                  ),
                  cardItem(
                    'Canceled',
                    controller.summary.value.canceled,
                    Colors.red[100]!,
                  ),
                  cardItem(
                    'Attendance Rate',
                    controller.kpi.value.attendanceRate,
                    Colors.teal[100]!,
                    suffix: '%',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Doctor Stats
            const Text(
              'Doctor Statistics',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            doctorStatsList(),
            const SizedBox(height: 30),
          ],
        );
      }),
    );
  }

  // ================= Chart Widget =================
  Widget appointmentsChart() {
    return Obx(() {
      if (controller.appointmentsTrend.isEmpty) {
        return const Center(child: Text('No data available'));
      }

      var chartData = controller.appointmentsTrend;
      return Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: LineChart(
            LineChartData(
              minY: 0,
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      int index = value.toInt();
                      if (index < 0 || index >= chartData.length) {
                        return const Text('');
                      }
                      return Text(
                        chartData[index].date.split("-").last,
                        style: const TextStyle(fontSize: 12),
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
                ),
                LineChartBarData(
                  spots: List.generate(
                    chartData.length,
                    (i) =>
                        FlSpot(i.toDouble(), chartData[i].completed.toDouble()),
                  ),
                  isCurved: true,
                  color: Colors.green,
                  barWidth: 3,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  // ================= Summary Cards =================
  Widget cardItem(String title, int value, Color color, {String suffix = ''}) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Text(
            '$value$suffix',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(color: Colors.black54, fontSize: 15),
          ),
        ],
      ),
    );
  }

  // ================= Doctor Stats =================
  Widget doctorStatsList() {
    return Obx(() {
      var doctors =
          controller.doctorStats.isEmpty
              ? [
                DoctorStat(
                  doctorId: 0,
                  doctorName: "No Doctors",
                  patientsCount: 0,
                ),
              ]
              : controller.doctorStats;

      return Column(
        children:
            doctors.map((doc) {
              return Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.blueGrey[50],
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue[100],
                    child: Text(
                      doc.patientsCount.toString(),
                      style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    doc.doctorName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('Patients Count: ${doc.patientsCount}'),
                ),
              );
            }).toList(),
      );
    });
  }
}
