import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:medilink/controller/PatientsController.dart';
import 'package:medilink/core/class/crud.dart';
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
    required this.patientId, 
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
                patientId: patientId, 
              ),
            );
          },
        ),
        SizedBox(width: 2),
        IconButton(
          // icon: const Icon(Icons.delete, color: Colors.red),
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () async {
            final confirm = await Get.defaultDialog<bool>(
              title: " Confirm deletion",
              middleText: "Are you sure you want to delete this patient?",
              textCancel: "cancel",
              textConfirm: "delete",
              onConfirm: () => Get.back(result: true),
              onCancel: () => Get.back(result: false),
            );

            if (confirm == true) {
              Crud crud = Crud();
              final response = await crud.deleteData(
                "https://medical.doctorme.site/api/secretary/patients/$patientId",
              );

              response.fold((failure) => Get.snackbar("Error", "Delete failed"), (
                data,
              ) {
                if (data['success'] == true) {
                  Get.snackbar("Done", "Patient successfully deleted");

                 
                  final patientsController = Get.find<PatientsController>();
                  patientsController.patients.removeWhere(
                    (p) => p.id == patientId,
                  );
                  patientsController.update();
                } else {
                  Get.snackbar("error", data['message'] ?? "Delete failed");
                }
              });
            }
          },
        ),
      ],
    );
  }
}