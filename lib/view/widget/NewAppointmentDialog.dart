// lib/view/widget/NewAppointmentDialog.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medilink/controller/PatientsController.dart';
import 'package:medilink/controller/appointmentsController.dart';
import 'package:medilink/controller/doctors_controller.dart';
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
  DateTime? selectedDateTime; // يحتوي التاريخ والوقت معاً
  final notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final doctorCtrl = Get.put(DoctorController());
    final patientCtrl = Get.put(PatientsController());
    if (doctorCtrl.doctors.isEmpty) doctorCtrl.loadDoctors();
    if (patientCtrl.patients.isEmpty) patientCtrl.getPatients();
    selectedPatientId = widget.patientId;
  }

  int? _resolvePatientId() => selectedPatientId ?? widget.patientId;

  String _formatRequestedDate(DateTime dt) {
    // صيغة مطلوبة من السيرفر: yyyy-MM-dd HH:mm:ss
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dt.toLocal());
  }

  Future<void> _pickDateTime(BuildContext ctx) async {
    final date = await showDatePicker(
      context: ctx,
      initialDate: selectedDateTime ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 2)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (date == null) return;
    final time = await showTimePicker(
      context: ctx,
      initialTime: selectedDateTime != null
          ? TimeOfDay(hour: selectedDateTime!.hour, minute: selectedDateTime!.minute)
          : TimeOfDay.now(),
    );
    if (time == null) return;
    setState(() {
      selectedDateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
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
            // Patient
            GetBuilder<PatientsController>(builder: (pc) {
              final patients = pc.patients;
              if (patients.isEmpty) {
                return const SizedBox(height: 60, child: Center(child: CircularProgressIndicator()));
              }
              return DropdownButtonFormField<int>(
                decoration: const InputDecoration(labelText: 'Patient (booked by)'),
                items: patients.map<DropdownMenuItem<int>>((PatientModel p) {
                  return DropdownMenuItem<int>(value: p.id, child: Text(p.fullName));
                }).toList(),
                value: selectedPatientId ?? widget.patientId,
                onChanged: (v) => setState(() => selectedPatientId = v),
              );
            }),
            const SizedBox(height: 10),

            // Doctor
            GetBuilder<DoctorController>(builder: (dc) {
              final docs = dc.doctors;
              if (docs.isEmpty) {
                return const SizedBox(height: 60, child: Center(child: CircularProgressIndicator()));
              }
              return DropdownButtonFormField<int>(
                decoration: const InputDecoration(labelText: 'Doctor'),
                items: docs.map<DropdownMenuItem<int>>((DoctorModel d) {
                  return DropdownMenuItem<int>(value: d.id, child: Text(d.fullName));
                }).toList(),
                value: selectedDoctorId,
                onChanged: (v) => setState(() => selectedDoctorId = v),
              );
            }),
            const SizedBox(height: 10),

            // Requested date (date + time) — العرض يكون بصيغة yyyy-MM-dd HH:mm:ss
            TextFormField(
              readOnly: true,
              decoration: const InputDecoration(labelText: 'Requested date (YYYY-MM-DD HH:mm:ss)'),
              controller: TextEditingController(
                  text: selectedDateTime == null ? '' : _formatRequestedDate(selectedDateTime!)),
              onTap: () => _pickDateTime(context),
            ),
            const SizedBox(height: 10),

            // Notes
            TextFormField(controller: notesController, decoration: const InputDecoration(labelText: 'Notes'), maxLines: 3),

          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () async {
            // validations
            if (_resolvePatientId() == null) {
              Get.snackbar('Error', 'Please select a patient');
              return;
            }
            if (selectedDoctorId == null) {
              Get.snackbar('Error', 'Please select a doctor');
              return;
            }
            if (selectedDateTime == null) {
              Get.snackbar('Error', 'Please choose date and time');
              return;
            }

            final patientId = _resolvePatientId()!;
            final doctorId = selectedDoctorId!;
            final requestedDateStr = _formatRequestedDate(selectedDateTime!);
            final notes = notesController.text.isEmpty ? null : notesController.text;

            print('[UI] Book minimal -> doctorId=$doctorId patientId=$patientId requested_date=$requestedDateStr notes=$notes');

            final ok = await appCtrl.bookAppointmentMinimal(
              doctorId: doctorId,
              patientId: patientId,
              requestedDate: requestedDateStr,
              notes: notes,
            );

            if (ok) {
              // close dialog only on success
              if (Navigator.canPop(context)) Navigator.pop(context);
            } else {
              // خطأ: الكونترولر عرض snackbar، ابقي الديالوج مفتوح
            }
          },
          child: const Text('Book Appointment'),
        ),
      ],
    );
  }
}
