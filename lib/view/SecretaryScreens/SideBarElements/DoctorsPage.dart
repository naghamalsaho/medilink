import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink/controller/doctors_controller.dart';
import 'package:medilink/core/class/handlingdataview.dart';
import 'package:medilink/core/services/MyServices.dart';
import 'package:medilink/view/widget/DoctorsPage/AddDoctorDialog.dart';
import 'package:medilink/view/widget/DoctorsPage/DoctorCard.dart';
import 'package:medilink/view/widget/DoctorsPage/DoctorHeader.dart';

class DoctorsPage extends StatelessWidget {
  const DoctorsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DoctorController ctrl = Get.put(DoctorController());

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const DoctorHeadr(),
            const SizedBox(height: 16),

            const _FiltersSection(),

            const SizedBox(height: 24),
            const Text(
              'List of doctors',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: Obx(() {
                return HandlingDataView(
                  statusRequest: ctrl.status.value,
                  widget: ListView.builder(
                    itemCount: ctrl.doctors.length,
                    itemBuilder: (ctx, idx) {
                      final d = ctrl.doctors[idx];
                      return DoctorCard(
                        id: d.id,
                        name: d.fullName,
                        specialty: d.specialty ?? '—',
                        qualifications: d.aboutMe ?? '—',
                        experience: '${d.yearsOfExperience ?? 0} years',
                        phone: d.email,
                        email: d.email,
                        address: d.address ?? '—',
                        schedule: d.workingHours.join(', '),
                        patients: d.totalPatients,
                        appointments: d.totalAppointments,
                        isActive: true,
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _FiltersSection extends StatelessWidget {
  const _FiltersSection();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DropdownButton<String>(
          value: 'all specialties',
          items: const [
            DropdownMenuItem(
              value: 'all specialties',
              child: Text('all specialties'),
            ),
            DropdownMenuItem(
              value: 'General Medicine',
              child: Text('General Medicine'),
            ),
            DropdownMenuItem(value: 'Surgery', child: Text('Surgery')),
          ],
          onChanged: (_) {},
        ),
        const SizedBox(width: 16),
        const Expanded(child: _SearchField()),
      ],
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField();

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText:
            'Searching for a doctor by name, specialty, or phone number...',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onChanged: (val) {
        Get.find<DoctorController>().searchDoctors(val);
      },
    );
  }
}
