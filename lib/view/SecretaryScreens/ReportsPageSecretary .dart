import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:medilink/controller/ReportsControllerSecretary%20.dart';

class ReportsPageSecretary extends StatefulWidget {
  ReportsPageSecretary({Key? key}) : super(key: key);

  @override
  State<ReportsPageSecretary> createState() => _ReportsPageSecretaryState();
}

class _ReportsPageSecretaryState extends State<ReportsPageSecretary> {
  final ReportsControllerSecretary controller = Get.put(
    ReportsControllerSecretary(),
  );

  String selectedScope = "week"; // default

  Future<void> pickCustomRange() async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
      initialDateRange: DateTimeRange(
        start: controller.startDate,
        end: controller.endDate,
      ),
    );

    if (picked != null) {
      controller.startDate = picked.start;
      controller.endDate = picked.end;
      controller.fetchReports(
        scope: "custom",
        from: picked.start,
        to: picked.end,
      );
      setState(() => selectedScope = "custom");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          controller.fetchReports(scope: selectedScope);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with export button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Secretary Reports',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green, // لون الزر
                      ),
                      icon: const Icon(Icons.picture_as_pdf),
                      label: const Text("Export PDF"),
                      onPressed: () => controller.exportPDF(),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Scope selection
                Row(
                  children: [
                    ChoiceChip(
                      label: const Text('Day'),
                      selected: selectedScope == "day",
                      onSelected: (val) {
                        setState(() => selectedScope = "day");
                        controller.fetchReports(scope: "day");
                      },
                    ),
                    const SizedBox(width: 10),
                    ChoiceChip(
                      label: const Text('Week'),
                      selected: selectedScope == "week",
                      onSelected: (val) {
                        setState(() => selectedScope = "week");
                        controller.fetchReports(scope: "week");
                      },
                    ),
                    const SizedBox(width: 10),
                    ChoiceChip(
                      label: const Text('Custom'),
                      selected: selectedScope == "custom",
                      onSelected: (val) => pickCustomRange(),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Chart
                SizedBox(
                  height: 300,
                  width: double.infinity,
                  child: RepaintBoundary(
                    key: controller.chartKey,
                    child: appointmentsChart(),
                  ),
                ),
                const SizedBox(height: 20),

                // Summary
                const Text(
                  'Appointments Summary',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      summaryCard(
                        'Total',
                        controller.summary.value.total,
                        Colors.blue[100]!,
                      ),
                      summaryCard(
                        'Attended',
                        controller.summary.value.attended,
                        Colors.green[100]!,
                      ),
                      summaryCard(
                        'Absent',
                        controller.summary.value.absent,
                        Colors.red[100]!,
                      ),
                      summaryCard(
                        'Attendance Rate',
                        controller.kpi.value.attendanceRate,
                        Colors.teal[100]!,
                        suffix: '%',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // New Patients
                const Text(
                  'New Patients',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                DataTable(
                  headingRowColor: MaterialStateColor.resolveWith(
                    (states) => Colors.blueGrey.shade50,
                  ),
                  columns: const [
                    DataColumn(label: Text('ID')),
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Phone')),
                    DataColumn(label: Text('Email')),
                    DataColumn(label: Text('Joined At')),
                  ],
                  rows:
                      controller.newPatients.map((p) {
                        return DataRow(
                          cells: [
                            DataCell(Text(p.id.toString())),
                            DataCell(Text(p.name)),
                            DataCell(Text(p.phone ?? '-')),
                            DataCell(Text(p.email ?? '-')),
                            DataCell(Text(p.joinedAt ?? '-')),
                          ],
                        );
                      }).toList(),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget appointmentsChart() {
    return Obx(() {
      if (controller.appointmentsTrend.isEmpty) {
        return const Center(child: Text('No data available'));
      }

      return LineChart(
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
                  if (index < 0 ||
                      index >= controller.appointmentsTrend.length) {
                    return const Text('');
                  }
                  return Text(
                    controller.appointmentsTrend[index].date.split("-").last,
                  );
                },
              ),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(
                controller.appointmentsTrend.length,
                (i) => FlSpot(
                  i.toDouble(),
                  controller.appointmentsTrend[i].newRequests.toDouble(),
                ),
              ),
              isCurved: true,
              color: Colors.blue,
              barWidth: 3,
            ),
            LineChartBarData(
              spots: List.generate(
                controller.appointmentsTrend.length,
                (i) => FlSpot(
                  i.toDouble(),
                  controller.appointmentsTrend[i].completed.toDouble(),
                ),
              ),
              isCurved: true,
              color: Colors.green,
              barWidth: 3,
            ),
          ],
        ),
      );
    });
  }

  Widget summaryCard(
    String title,
    int value,
    Color color, {
    String suffix = '',
  }) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            '$value$suffix',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(title, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
