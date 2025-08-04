import 'package:flutter/material.dart';

class AppointmentsList extends StatelessWidget {
  final List<dynamic> appointments;

  const AppointmentsList({Key? key, required this.appointments})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (appointments.isEmpty) {
      return const Center(child: Text("لا يوجد مواعيد اليوم"));
    }

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
            ...appointments.map((item) => _buildItem(item)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(dynamic data) {
    final status = data['status'] ?? "Pending";
    final time = data['time'] ?? "غير محدد";
    final name = data['patient_name'] ?? "بدون اسم";
    final desc = data['description'] ?? "لا يوجد وصف";

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
}
