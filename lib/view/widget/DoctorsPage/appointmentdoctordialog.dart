import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medilink/core/class/statusrequest.dart';
import 'package:medilink/controller/doctors_controller.dart'; 

class AppointmentListDialog extends StatelessWidget {
  final int doctorId;
  const AppointmentListDialog({Key? key, required this.doctorId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<DoctorController>();

    return Dialog(
      child: Container(
        width: 600,
        height: 400,
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          final status = ctrl.appointmentsStatus.value;

          if (status == StatusRequest.loading) {
            return const SizedBox(
              height: 200,
              child: Center(child: CircularProgressIndicator()),
            );
          }

          if (status != StatusRequest.success) {
           
            return SizedBox(
              height: 200,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Failed to load appointments or no appointments.'),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () async {
                        await ctrl.loadDoctorAppointments(doctorId);
                      },
                      child: const Text('  try again'),
                    ),
                    const SizedBox(height: 8),
                    Text('the condition: $status'),
                  ],
                ),
              ),
            );
          }

          final list = ctrl.doctorAppointments; 
          if (list.isEmpty) {
            return SizedBox(
              height: 160,
              child: Center(child: Text('There are no appointments for this doctor.')),
            );
          }

          return Column(
            children: [
              Row(
                children: [
                  Text('Doctor appointments', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Spacer(),
                  IconButton(onPressed: () => Get.back(), icon: Icon(Icons.close))
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.separated(
                  itemCount: list.length,
                  separatorBuilder: (_, __) => Divider(),
                  itemBuilder: (context, index) {
                    final appt = list[index];
                    final patient = appt['patient_name'] ?? appt['name'] ?? 'patient';
                    final rawTime = appt['time'] ?? appt['appointment_time'] ?? appt['date_time'];
                    String timeText = rawTime?.toString() ?? '—';

                    
                    try {
                      final dt = DateTime.parse(timeText);
                      timeText = DateFormat('yyyy-MM-dd – HH:mm').format(dt);
                    } catch (e) {
                     
                    }

                    final statusText = appt['status'] ?? '';

                    return ListTile(
                      leading: Icon(Icons.person_outline),
                      title: Text(patient),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('time: $timeText'),
                          if (statusText.toString().isNotEmpty) Text('الحالة: $statusText'),
                        ],
                      ),
                      onTap: () {
                       
                      },
                    );
                  },
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
