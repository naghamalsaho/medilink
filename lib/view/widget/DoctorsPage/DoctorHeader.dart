import 'package:flutter/material.dart';
import 'package:medilink/view/widget/NewAppointmentDialog.dart';
import 'package:medilink/view/widget/PatientsPage/AddPatientDialog.dart';

class DoctorHeadr extends StatelessWidget {
  const DoctorHeadr({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          "Doctors Management",
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
          label: const Text("Add New Doctor"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          ),
        ),
      ],
    );
  }
}
