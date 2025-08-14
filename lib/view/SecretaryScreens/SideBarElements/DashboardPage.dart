import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink/controller/DashbordController.dart';
import 'package:medilink/core/class/statusrequest.dart';
import 'package:medilink/view/widget/dashbord/AppointmentListCard.dart';
import 'package:medilink/view/widget/dashbord/NotificationRow.dart';
import 'package:medilink/view/widget/dashbord/StatCard%20.dart';
import 'package:medilink/view/widget/dashbord/WelcomeBanner%20.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.put(DashboardController());

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Obx(() {
        if (controller.statusRequest.value == StatusRequest.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.statusRequest.value == StatusRequest.failure) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  " Failed to load data  ",
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => controller.fetchDashboardData(),
                  child: const Text("try again "),
                ),
              ],
            ),
          );
        }

      
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const WelcomeBanner(),
              const SizedBox(height: 20),

              Center(
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    StatsCard(
                      title: " The Pending Appointments",
                      value: controller.pendingAppointments.value.toString(),
                      badge: "", 
                      icon: Icons.access_time,
                      color: Colors.orange,
                      token: '',
                    ),
                    StatsCard(
                      title: "new files",
                      value: controller.newFiles.value.toString(),
                      badge: "",
                      icon: Icons.description_outlined,
                      color: Colors.purple,
                      token: '',
                    ),
                    StatsCard(
                      title: "Today's Appointments",
                      value:
                          controller.todaysAppointmentsCount.value.toString(),
                      badge: "",
                      icon: Icons.calendar_today_outlined,
                      color: Colors.green,
                      token: '',
                    ),
                    StatsCard(
                      title: "Total Patients",
                      value: controller.totalPatients.value.toString(),
                      badge: "",
                      icon: Icons.groups_outlined,
                      color: Colors.blue,
                      token: '',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        ImportantNotifications(),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),

                  const SizedBox(width: 5),

                  Expanded(
                    flex: 2,
                    child:
                        controller.todaysAppointments.isEmpty
                            ? const Padding(
                              padding: EdgeInsets.symmetric(vertical: 30),
                              child: Center(
                                child: Text("There are no appointments today."),
                              ),
                            )
                            : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: controller.todaysAppointments.length,
                              itemBuilder: (context, index) {
                                var appt = controller.todaysAppointments[index];

                                final status = appt['status'] ?? "Pending";
                                final time = appt['time'] ?? "undefined ";
                                final name = appt['patient_name'] ?? " no name";
                                final desc =
                                    appt['description'] ?? "  No description";

                                final color =
                                    status == "Confirmed"
                                        ? Colors.blue
                                        : status == "Pending"
                                        ? Colors.orange
                                        : Colors.green;

                                return Card(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ListTile(
                                    leading: Chip(
                                      label: Text(
                                        status,
                                        style: TextStyle(
                                          color: color,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      backgroundColor: color.withOpacity(0.1),
                                    ),
                                    title: Text(
                                      name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(desc),
                                    trailing: Text(time),
                                  ),
                                );
                              },
                            ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}