import 'package:flutter/material.dart';

class PatientDetailsDialog extends StatelessWidget {
  final String name, email, phone, age, condition, lastVisit, status;

  const PatientDetailsDialog({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
    required this.age,
    required this.condition,
    required this.lastVisit,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Patient Details'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow("Name", name),
          _buildDetailRow("Email", email),
          _buildDetailRow("Phone", phone),
          _buildDetailRow("Age", age),
          _buildDetailRow("Condition", condition),
          _buildDetailRow("Last Visit", lastVisit),
          _buildDetailRow("Status", status),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Close"),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Flexible(child: Text(value)),
        ],
      ),
    );
  }
}
