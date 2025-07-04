import 'package:flutter/material.dart';
import 'patient_row.dart';

class PatientsTable extends StatelessWidget {
  const PatientsTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Column(
            children: const [
              TableHeader(),
              Divider(),
              PatientRow(
                name: "Ahmed Mohamed Ali",
                email: "ahmed@email.com",
                phone: "05012345678",
                age: "35",
                condition: "Diabetes",
                lastVisit: "2024-01-15",
                status: "Active",
              ),
              PatientRow(
                name: "Fatima Saad",
                email: "fatima@email.com",
                phone: "05098765432",
                age: "28",
                condition: "Blood Pressure",
                lastVisit: "2024-01-20",
                status: "Active",
              ),
              PatientRow(
                name: "Mohamed Khaled",
                email: "mohammed@email.com",
                phone: "0505555555",
                age: "42",
                condition: "Heart Disease",
                lastVisit: "2024-01-10",
                status: "Follow-up",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TableHeader extends StatelessWidget {
  const TableHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Row(
          children: const [
            Expanded(flex: 2, child: Text("Patient Name")),
            Expanded(child: Text("Age")),
            Expanded(child: Text("Phone")),
            Expanded(child: Text("Condition")),
            Expanded(child: Text("Last Visit")),
            Expanded(child: Text("Status")),
            Expanded(child: Text("Actions")),
          ],
        ),
      ),
    );
  }
}
