// lib/view/SecretaryScreens/DoctorDetailPage.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink/controller/doctors_controller.dart';
import 'package:medilink/core/class/statusrequest.dart';


class DoctorDetailPage extends StatelessWidget {
  const DoctorDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<DoctorController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Doctor Details')),
      body: Obx(() {
        if (ctrl.status.value == StatusRequest.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        final doc = ctrl.selectedDoctor.value;
        if (doc == null) {
          return const Center(child: Text('Failed to load doctor.'));
        }
        return Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              Text('Name: ${doc.fullName}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Email: ${doc.email}'),
              Text('Address: ${doc.address ?? '-'}'),
              const SizedBox(height: 8),
              Text('About Me:', style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(doc.aboutMe ?? '-'),
              const SizedBox(height: 8),
              Text('Years of Experience: ${doc.yearsOfExperience ?? 0}'),
              Text('Specialty: ${doc.specialty ?? '-'}'),
              const SizedBox(height: 16),
              const Text('Working Hours:', style: TextStyle(fontWeight: FontWeight.bold)),
              ...doc.workingHours.map((w) {
                return Text('${w['day_of_week']}: ${w['start_time']} - ${w['end_time']}');
              }),
              const SizedBox(height: 16),
              Text('Total Patients: ${doc.totalPatients}'),
              Text('Total Appointments: ${doc.totalAppointments}'),
            ],
          ),
        );
      }),
    );
  }
}
