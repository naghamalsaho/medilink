import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:medilink/view/SecretaryScreens/SideBarElements/MedicalFilesDialog%20.dart';
import 'package:medilink/view/widget/PatientsPage/action_buttons.dart';
import 'package:medilink/view/widget/PatientsPage/status_badge.dart';

class PatientRow extends StatelessWidget {
  final String name, email, phone, age, condition, lastVisit, status;
  final int patientId;

  const PatientRow({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
    required this.age,
    required this.condition,
    required this.lastVisit,
    required this.status,
    required this.patientId,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    email,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            SizedBox(width: 85),
            SizedBox(width: 80, child: Text("$age years")),
            SizedBox(width: 60),
            SizedBox(
              width: 155,
              child: Row(
                children: [const Icon(Icons.phone, size: 16), Text(" $phone")],
              ),
            ),
            SizedBox(width: 20),
            SizedBox(width: 100, child: Text(condition)),
            SizedBox(width: 80),
            SizedBox(width: 100, child: Text(lastVisit)),
            SizedBox(width: 40),
            SizedBox(width: 80, child: StatusBadge(status: status)),
            const SizedBox(width: 20),
            // 🌟 أيقونة ملفات المريض
            IconButton(
              icon: const Icon(Icons.folder, color: Colors.blue),
              tooltip: "Medical Files",
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => MedicalFilesDialog(patientId: patientId),
                );
              },
            ),
            const SizedBox(width: 20),
            SizedBox(
              width: 110,
              child: ActionButtons(
                name: name,
                email: email,
                phone: phone,
                age: age,
                status: status,
                condition: condition,
                lastVisit: lastVisit,
                patientId: patientId,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
