import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink/view/AdminCenterScreens/AdminDashbord/WelcomeBanner.dart';
import 'package:medilink/view/widget/dashbord/StatCard%20.dart';

class AdminDashbord extends StatelessWidget {
  const AdminDashbord({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AdminWelcomeBanner(), // ✅ Top banner
            const SizedBox(height: 20),

            // ✅ Stats cards
            Center(
              child: Wrap(
                spacing: 20,
                children: const [
                  StatsCard(
                    title: "Total Appointments",
                    value: "40",
                    badge: "2-",
                    icon: Icons.access_time,
                    color: Colors.blue,
                    token: '',
                  ),
                  StatsCard(
                    title: "Active Secretaries",
                    value: "3",
                    badge: "3+",
                    icon: Icons.description_outlined,
                    color: Color(0xFF1E7F5C),
                    token: '',
                  ),
                  StatsCard(
                    title: "Total Doctors",
                    value: "13",
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

            // ✅ Content below cards
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                // ⬅️ Center Status
                Expanded(flex: 1, child: CenterStatusWidget()),
                SizedBox(width: 20),
                // ➡️ Today Summary
                Expanded(flex: 2, child: TodaySummaryWidget()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// ✅ Center Status (Progress Indicators)
class CenterStatusWidget extends StatelessWidget {
  const CenterStatusWidget({super.key});

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

            _buildProgress("Occupancy Rate", 0.75, Colors.green),
            const SizedBox(height: 10),
            _buildProgress("Patient Satisfaction", 0.85, Colors.blue),
            const SizedBox(height: 10),
            _buildProgress("General Performance", 0.90, Colors.purple),
          ],
        ),
      ),
    );
  }

  Widget _buildProgress(String title, double value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 5),
        LinearProgressIndicator(
          value: value,
          color: color,
          backgroundColor: Colors.grey.shade300,
          minHeight: 8,
          borderRadius: BorderRadius.circular(10),
        ),
      ],
    );
  }
}

/// ✅ Today Summary
class TodaySummaryWidget extends StatelessWidget {
  const TodaySummaryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Today Summary",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.add_circle_outline, color: Colors.blue),
              title: Text("New Appointments"),
              trailing: Text(
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                "28",
              ),
            ),
            ListTile(
              leading: Icon(Icons.check_circle_outline, color: Colors.green),
              title: Text("Completed Appointments"),
              trailing: Text(
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                "412",
              ),
            ),
            ListTile(
              leading: Icon(Icons.cancel_outlined, color: Colors.red),
              title: Text("Pending Appointments"),
              trailing: Text(
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                "384",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
