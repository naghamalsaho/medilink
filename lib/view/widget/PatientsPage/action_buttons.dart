import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:medilink/view/widget/PatientsPage/EditPatientDialog.dart';

class ActionButtons extends StatelessWidget {
  final String name, email, phone, age, status, condition, lastVisit;
  final int patientId; // أضفنا هذا فقط

  const ActionButtons({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
    required this.age,
    required this.status,
    required this.condition,
    required this.lastVisit,
    required this.patientId, // أضفنا هذا فقط
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.edit, color: Colors.orange),
          onPressed: () {
            Get.dialog(
              EditPatientDialog(
                name: name,
                email: email,
                phone: phone,
                age: age,
                lastVisit: lastVisit,
                status: status,
                condition: condition,
                patientId: patientId, // أضفنا هذا فقط
              ),
            );
          },
        ),
      ],
    );
  }
}
