import 'package:flutter/material.dart';
import 'package:medilink/view/widget/NewAppointmentDialog.dart';

class Appointmentheader extends StatelessWidget {
  const Appointmentheader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          "Appointment Management",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        SizedBox(width: 300),
        const SizedBox(width: 12),
        ElevatedButton.icon(
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => const NewAppointmentDialog(),
            );
          },
          icon: const Icon(Icons.add),
          label: const Text("Add New Appointment"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          ),
        ),
      ],
    );
  }
}
