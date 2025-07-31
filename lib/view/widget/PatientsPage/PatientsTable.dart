import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink/controller/PatientsController.dart';
import 'package:medilink/core/class/statusrequest.dart';
import 'patient_row.dart';

class PatientsTable extends StatelessWidget {
  const PatientsTable({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PatientsController>(
      init: PatientsController(),
      builder: (controller) {
        if (controller.statusRequest == StatusRequest.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.statusRequest == StatusRequest.failure) {
          return const Center(child: Text("فشل تحميل البيانات"));
        }

        if (controller.patients.isEmpty) {
          return const Center(child: Text("لا يوجد مرضى"));
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              const TableHeader(),
              const Divider(),
              ...controller.patients.map(
                (patient) => PatientRow(
                  name: patient.fullName,
                  email: patient.email,
                  phone: patient.phone,
                  age: patient.age,
                  condition: patient.condition ?? "-",
                  lastVisit: patient.lastVisit ?? "-",
                  status: patient.status ?? "N/A",
                ),
              ),
            ],
          ),
        );
      },
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
