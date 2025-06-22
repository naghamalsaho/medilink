import 'package:flutter/material.dart';
import 'package:medilink/view/widget/dashbord/StatCard%20.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ Page title
          const Text(
            'Dashboard',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 24),

          // ✅ Stat cards (responsive grid)
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: const [
              StatCard(
                title: 'Patients',
                value: '1,248',
                icon: Icons.groups,
                color: Colors.blue,
              ),
              StatCard(
                title: 'Appointments',
                value: '329',
                icon: Icons.calendar_today,
                color: Colors.green,
              ),
              StatCard(
                title: 'Doctors',
                value: '27',
                icon: Icons.medical_services,
                color: Colors.purple,
              ),
              StatCard(
                title: 'Reports',
                value: '89',
                icon: Icons.insert_chart,
                color: Colors.orange,
              ),
            ],
          ),

          const SizedBox(height: 32),

          // ✅ Placeholder for charts
          Container(
            height: 240,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: const Center(
              child: Text(
                'Analytics Chart (Coming Soon)',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
