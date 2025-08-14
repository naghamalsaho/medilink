// lib/view/widget/NewAppointmentDialog.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medilink/controller/PatientsController.dart';
import 'package:medilink/controller/appointmentsController.dart';
import 'package:medilink/controller/doctors_controller.dart';
import 'package:medilink/core/services/MyServices.dart';
import 'package:medilink/models/doctor_model.dart';
import 'package:medilink/models/patient_model.dart';
class NewAppointmentDialog extends StatefulWidget {
  final int? patientId; 
  const NewAppointmentDialog({Key? key, this.patientId}) : super(key: key);

  @override
  _NewAppointmentDialogState createState() => _NewAppointmentDialogState();
}

class _NewAppointmentDialogState extends State<NewAppointmentDialog> {
  int? selectedPatientId;
  int? selectedDoctorId;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String? status;
  String? attendanceStatus;
  final notesController = TextEditingController();

  final statuses = ['pending', 'confirmed', 'cancelled'];
  final attendanceOptions = ['present', 'absent'];

  @override
  void initState() {
    super.initState();
   
    final doctorCtrl = Get.put(DoctorController());
    final patientCtrl = Get.put(PatientsController());
  
    if (doctorCtrl.doctors.isEmpty) doctorCtrl.loadDoctors();
    if (patientCtrl.patients.isEmpty) patientCtrl.getPatients();

    
    selectedPatientId = widget.patientId;
  }

  int? _resolvePatientId() {
    return selectedPatientId ?? widget.patientId;
  }

  @override
  Widget build(BuildContext context) {
    final appCtrl = Get.find<AppointmentsController>();
  
    final doctorCtrl = Get.find<DoctorController>();
    final patientCtrl = Get.find<PatientsController>();

    return AlertDialog(
      title: const Text('Book New Appointment'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
          
            GetBuilder<PatientsController>(
              builder: (pc) {
                final patients = pc.patients;
                if (patients.isEmpty) {
                  return const SizedBox(
                      height: 60,
                      child: Center(child: CircularProgressIndicator()));
                }
                return DropdownButtonFormField<int>(
                  decoration: const InputDecoration(labelText: 'Patient (booked by)'),
                  items: patients.map<DropdownMenuItem<int>>((PatientModel p) {
               
                    return DropdownMenuItem<int>(
                      value: p.id,
                      child: Text(p.fullName),
                    );
                  }).toList(),
                  value: selectedPatientId ?? widget.patientId,
                  onChanged: (v) => setState(() => selectedPatientId = v),
                );
              },
            ),

            const SizedBox(height: 10),

            GetBuilder<DoctorController>(
              builder: (dc) {
                final docs = dc.doctors;
                if (docs.isEmpty) {
                  return const SizedBox(
                      height: 60,
                      child: Center(child: CircularProgressIndicator()));
                }
                return DropdownButtonFormField<int>(
                  decoration: const InputDecoration(labelText: 'Doctor'),
                  items: docs.map<DropdownMenuItem<int>>((DoctorModel d) {
                    return DropdownMenuItem<int>(
                      value: d.id,
                      child: Text(d.fullName),
                    );
                  }).toList(),
                  value: selectedDoctorId,
                  onChanged: (v) => setState(() => selectedDoctorId = v),
                );
              },
            ),

            const SizedBox(height: 10),

          
            TextFormField(
              readOnly: true,
              decoration: const InputDecoration(labelText: 'Date'),
              controller: TextEditingController(
                text: selectedDate == null ? '' : DateFormat('yyyy/MM/dd').format(selectedDate!),
              ),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate ?? DateTime.now(),
                  firstDate: DateTime.now().subtract(const Duration(days: 1)),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (picked != null) setState(() => selectedDate = picked);
              },
            ),

            const SizedBox(height: 10),

          
            TextFormField(
              readOnly: true,
              decoration: const InputDecoration(labelText: 'Time'),
              controller: TextEditingController(text: selectedTime == null ? '' : selectedTime!.format(context)),
              onTap: () async {
                final picked = await showTimePicker(context: context, initialTime: selectedTime ?? TimeOfDay.now());
                if (picked != null) setState(() => selectedTime = picked);
              },
            ),

            const SizedBox(height: 10),

           
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Status'),
              items: statuses.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
              value: status,
              onChanged: (v) => setState(() => status = v),
            ),

            const SizedBox(height: 10),

            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Attendance'),
              items: attendanceOptions.map((a) => DropdownMenuItem(value: a, child: Text(a))).toList(),
              value: attendanceStatus,
              onChanged: (v) => setState(() => attendanceStatus = v),
            ),

            const SizedBox(height: 10),

            TextFormField(controller: notesController, decoration: const InputDecoration(labelText: 'Notes'), maxLines: 3),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () async {
        
            if (_resolvePatientId() == null) {
              Get.snackbar('Error', 'Please select a patient');
              return;
            }
            if (selectedDoctorId == null) {
              Get.snackbar('Error', 'Please select a doctor');
              return;
            }
            if (selectedDate == null) {
              Get.snackbar('Error', 'Please select a date');
              return;
            }
            if (status == null || attendanceStatus == null) {
              Get.snackbar('Error', 'Please select status and attendance');
              return;
            }

            final patientId = _resolvePatientId()!;
            final dateStr = DateFormat('yyyy/MM/dd').format(selectedDate!);

            print(' [UI] createAppointment -> doctorId=$selectedDoctorId patientId=$patientId date=$dateStr status=$status attendance=$attendanceStatus notes=${notesController.text}');

            await appCtrl.createAppointment(
              doctorId: selectedDoctorId!,
              patientId: patientId,
              date: selectedDate!,
              apptStatus: status!,
              attendanceStatus: attendanceStatus!,
              notes: notesController.text.isEmpty ? null : notesController.text,
            );

            Navigator.pop(context);
          },
          child: const Text('Book Appointment'),
        ),
      ],
    );
  }
}