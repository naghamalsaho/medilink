import 'package:flutter/material.dart';

class HealthImportantNotifications extends StatelessWidget {
  const HealthImportantNotifications({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Important Notifications",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),

            _buildNotif(
              "Missed Appointment",
              "Ahmad Mohammad missed his appointment",
              Colors.red,
            ),
            _buildNotif(
              "Appointment Confirmed",
              "Fatima Saad confirmed her appointment",
              Colors.green,
            ),
            _buildNotif(
              "New Patient",
              "New patient has been registered",
              Colors.blue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotif(String title, String desc, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(Icons.circle, color: color, size: 12),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  desc,
                  style: TextStyle(color: Colors.grey[700], fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
