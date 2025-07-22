import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink/view/widget/dashbord/AppointmentListCard.dart';
import 'package:medilink/view/widget/dashbord/NotificationRow.dart';
import 'package:medilink/view/widget/dashbord/StatCard%20.dart';
import 'package:medilink/view/widget/dashbord/WelcomeBanner%20.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const WelcomeBanner(), // ✅ الترحيب العلوي
            const SizedBox(height: 20),

            // ✅ كروت الإحصائيات
            Center(
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: const [
                  StatsCard(
                    title: "Pending Appointments",
                    value: "4",
                    badge: "2-",
                    icon: Icons.access_time,
                    color: Colors.orange,
                  ),
                  StatsCard(
                    title: "New Files",
                    value: "8",
                    badge: "3+",
                    icon: Icons.description_outlined,
                    color: Colors.purple,
                  ),
                  StatsCard(
                    title: "Today's Appointments",
                    value: "23",
                    badge: "5+",
                    icon: Icons.calendar_today_outlined,
                    color: Colors.green,
                  ),
                  StatsCard(
                    title: "Total Patients",
                    value: "1,248",
                    badge: "12%",
                    icon: Icons.groups_outlined,
                    color: Colors.blue,
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
                      ImportantNotifications(),
                      SizedBox(height: 20),
                      // WeeklyStats(),
                    ],
                  ),
                ),
                SizedBox(width: 20),
                // ➡️ مواعيد اليوم
                Expanded(flex: 2, child: AppointmentsList()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
