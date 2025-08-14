import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink/view/HealthScreens/HealthNotificationRow.dart';
import 'package:medilink/view/HealthScreens/HealthWelcomeBanner%20.dart';
import 'package:medilink/view/HealthScreens/MedicalCentersCard.dart';
import 'package:medilink/view/widget/dashbord/AppointmentListCard.dart';
import 'package:medilink/view/widget/dashbord/NotificationRow.dart';

import 'package:medilink/view/widget/dashbord/StatCard%20.dart';
import 'package:medilink/view/widget/dashbord/WelcomeBanner%20.dart';

class HealthDashboardPage extends StatelessWidget {
  const HealthDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HealthWelcomeBanner(), // ✅ الترحيب العلوي
            const SizedBox(height: 20),

            // ✅ كروت الإحصائيات
            Center(
              child: Wrap(
                spacing: 20,
                // runSpacing: 16,
                children: const [
                  StatsCard(
                    title: "Total medical centers",
                    value: "40",
                    badge: "2-",
                    icon: Icons.access_time,
                    color: Colors.blue,
                    token: '',
                  ),
                  StatsCard(
                    title: "Active centers",
                    value: "38",
                    badge: "3+",
                    icon: Icons.description_outlined,
                    color: Color(0xFF1E7F5C),
                    token: '',
                  ),
                  StatsCard(
                    title: "Total doctors",
                    value: "2,800",
                    badge: "5+",
                    icon: Icons.calendar_today_outlined,
                    color: Colors.green,
                    token: '',
                  ),
                  StatsCard(
                    title: "Total Patients",
                    value: "45,692",
                    badge: "12%",
                    icon: Icons.groups_outlined,
                    color: Colors.blue,
                    token: '',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // ✅ محتوى أسفل البطاقات
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                // ⬅️ إشعارات مهمة + إحصائيات
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      HealthImportantNotifications(),
                      SizedBox(height: 20),
                      // WeeklyStats(),
                    ],
                  ),
                ),
                SizedBox(width: 5),
                // ➡️ مواعيد اليوم
                Expanded(flex: 2, child: MedicalCentersList()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}