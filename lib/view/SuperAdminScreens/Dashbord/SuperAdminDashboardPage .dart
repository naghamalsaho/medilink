import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink/controller/SuperAdminController/SuperAdminDashboardController%20.dart';
import 'package:medilink/view/SuperAdminScreens/Dashbord/WelcomeBanner%20.dart';
import 'package:medilink/view/widget/dashbord/StatCard%20.dart';
import 'package:medilink/view/widget/dashbord/WelcomeBanner%20.dart';

class SuperAdminDashboardPage extends StatelessWidget {
  SuperAdminDashboardPage({super.key});
  final SuperAdminDashboardController controller = Get.put(
    SuperAdminDashboardController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SuperAdminWelcomeBanner(),
              const SizedBox(height: 20),
              Center(
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    StatsCard(
                      title: "Medical Centers",
                      value: controller.centers.value.toString(),
                      icon: Icons.local_hospital,
                      color: Colors.deepPurple,
                      badge: "",
                      token: "",
                    ),
                    StatsCard(
                      title: "Doctors",
                      value: controller.doctors.value.toString(),
                      icon: Icons.medical_services,
                      color: Colors.blue,
                      badge: "",
                      token: "",
                    ),
                    StatsCard(
                      title: "Patients",
                      value: controller.patients.value.toString(),
                      icon: Icons.people,
                      color: Colors.green,
                      badge: "",
                      token: "",
                    ),
                    StatsCard(
                      title: "Appointments",
                      value: controller.appointments.value.toString(),
                      icon: Icons.calendar_today,
                      color: Colors.orange,
                      badge: "",
                      token: "",
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
