import 'package:flutter/material.dart';
import 'package:medilink/view/widget/PatientsPage/EditPatientDialog.dart';
import 'package:medilink/view/widget/PatientsPage/PatientDetailsDialog%20.dart';

class ActionButtons extends StatelessWidget {
  final String name, email, phone, age, gender, status, condition, lastVisit;

  const ActionButtons({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
    required this.age,
    required this.status,
    required this.condition,
    required this.gender,
    required this.lastVisit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.visibility, color: Colors.blue),
              tooltip: 'View Details',
              onPressed: () {
                showDialog(
                  context: context,
                  builder:
                      (context) => PatientDetailsDialog(
                        name: name,
                        email: email,
                        phone: phone,
                        age: age,
                        condition: condition,
                        lastVisit: lastVisit,
                        status: status,
                      ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.orange),
              tooltip: 'Edit Patient',
              onPressed: () {
                showDialog(
                  context: context,
                  builder:
                      (context) => EditPatientDialog(
                        name: name,
                        email: email,
                        phone: phone,
                        age: age,
                        condition: condition,
                        lastVisit: lastVisit,
                        status: status,
                      ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
