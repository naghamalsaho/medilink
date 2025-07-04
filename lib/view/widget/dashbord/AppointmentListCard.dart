import 'package:flutter/material.dart';

class AppointmentsList extends StatelessWidget {
  const AppointmentsList({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      [
        "Confirmed",
        "09:30",
        "Ahmad Mohammad",
        "Dr. Sami Ahmad – General Check",
      ],
      ["Pending", "10:15", "Fatima Saad", "Dr. Leila Hasan – Follow-up"],
      [
        "Completed",
        "11:00",
        "Mohammad Khaled",
        "Dr. Omar Hussein – Consultation",
      ],
      [
        "Confirmed",
        "11:45",
        "Aisha Ahmad",
        "Dr. Hiba Abdullah – Routine Check",
      ],
    ];

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Today's Appointments",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),
            ...items.map((item) => _buildItem(item)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(List<String> data) {
    final status = data[0];
    final time = data[1];
    final name = data[2];
    final desc = data[3];

    final color =
        status == "Confirmed"
            ? Colors.blue
            : status == "Pending"
            ? Colors.orange
            : Colors.green;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Chip(
            label: Text(status),
            backgroundColor: color.withOpacity(0.1),
            labelStyle: TextStyle(color: color),
          ),
          const SizedBox(width: 20),
          Text(time, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(name),
                Text(
                  desc,
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),

          const Icon(Icons.person_outline, color: Colors.grey),
        ],
      ),
    );
  }
<<<<<<< HEAD
}
=======
}
>>>>>>> 15f770e076bcf5587254b89510daaed02b8fc611
