import 'package:flutter/material.dart';
import 'package:medilink/view/widget/PatientsPage/AddPatientDialog.dart';

class HeaderBar extends StatelessWidget {
  const HeaderBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          "Patients Management",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        SizedBox(width: 300),
        const SizedBox(width: 12),
        ElevatedButton.icon(
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => const AddPatientDialog(),
            );
          },
          icon: const Icon(Icons.add),
          label: const Text("Add New Patient"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          ),
        ),
      ],
    );
  }
}
