

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medilink/controller/PatientsController.dart';
import 'package:medilink/controller/appointmentsController.dart';
import 'package:medilink/controller/doctors_controller.dart';
import 'package:medilink/core/class/handlingdataview.dart';
import 'package:medilink/core/class/statusrequest.dart';

import 'package:medilink/view/widget/appointmentHeader.dart';

class AppointmentsPage extends StatelessWidget {
  AppointmentsPage({Key? key}) : super(key: key);
  final selectedDate = DateTime.now();
void _showTodayDialog(BuildContext ctx, AppointmentsController ctrl) {
  showDialog(
    context: ctx,
    builder: (_) => AlertDialog(
      title: const Text('appointments today'),
      contentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      content: Builder(builder: (context) {
        final mq = MediaQuery.of(ctx);
        final maxW = mq.size.width * 0.5;
        final maxH = mq.size.height * 0.5;

        return ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: maxW,
            maxHeight: maxH,
            minWidth: 300,
            minHeight: 120,
          ),
          child: Obx(() {
            if (ctrl.status.value == StatusRequest.loading) {
              return const SizedBox(
                height: 140,
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (ctrl.todayAppts.isEmpty) {
              return const SizedBox(
                height: 120,
                child: Center(child: Text('There are no appointments today.')),
              );
            }

            return SizedBox(
              height: maxH - 20,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(ctrl.todayAppts.length, (i) {
                    final ap = ctrl.todayAppts[i];
                    final patient = (ap['patient_name'] ?? ap['patient'] ?? '-').toString();
                    final doctor = (ap['doctor_name'] ?? ap['doctor'] ?? '-').toString();
                    final time = (ap['time'] ?? ap['requested_time'] ?? '-').toString();
                    final specialty = (ap['specialty'] ?? '-').toString();
                    final notes = (ap['notes'] ?? ap['reason'] ?? '').toString();
                    final statusText = (ap['status'] ?? '-').toString().toLowerCase();

                    return Column(
                      children: [
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          leading: const Icon(Icons.person_outline),
                          title: Text(patient, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text('time: $time'),
                              Text('doctor: $doctor'),
                              if (specialty.isNotEmpty && specialty != 'null')
                                Text('specialty: $specialty'),
                              if (notes.isNotEmpty) Text('notes: $notes'),
                            ],
                          ),
                          trailing: statusText == 'approved'
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.check, color: Colors.green),
                                      onPressed: () async {
                                       await ctrl.markAttendance(
  appointmentId: ap['id'] as int,
  attendanceStatus: "present",
);
                                        Get.snackbar("تم التحديث", "تم تسجيل المريض حاضر");
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.close, color: Colors.red),
                                      onPressed: () async {
                                       await ctrl.markAttendance(
  appointmentId: ap['id'] as int,
  attendanceStatus: "absent",
);

                                        Get.snackbar("تم التحديث", "تم تسجيل المريض غائب");
                                      },
                                    ),
                                  ],
                                )
                              : Text(
                                  statusText,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: statusText == 'pending'
                                        ? Colors.orange
                                        : (statusText == 'approved'
                                            ? Colors.green
                                            : Colors.grey),
                                  ),
                                ),
                        ),
                        if (i < ctrl.todayAppts.length - 1) const Divider(height: 1),
                      ],
                    );
                  }),
                ),
              ),
            );
          }),
        );
      }),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إغلاق')),
      ],
    ),
  );
}



void _showIgnoredDialog(BuildContext ctx, AppointmentsController ctrl) {
  showDialog(
    context: ctx,
    builder: (_) => AlertDialog(
      title: const Text('Ignored appointments'),
      contentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      content: Builder(builder: (context) {
        final mq = MediaQuery.of(ctx);
        final maxW = mq.size.width * 0.5;
        final maxH = mq.size.height * 0.5;

        return ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: maxW,
            maxHeight: maxH,
            minWidth: 300,
            minHeight: 120,
          ),
          child: Obx(() {
            if (ctrl.ignoredRequests.isEmpty) {
              return const SizedBox(
                height: 120,
                child: Center(child: Text('No ignored appointments.')),
              );
            }

            return SizedBox(
              height: maxH - 20,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(ctrl.ignoredRequests.length, (i) {
                    final ap = ctrl.ignoredRequests[i];
                    final patient = (ap['patient_name'] ?? ap['patient'] ?? '-').toString();
                    final doctor = (ap['doctor_name'] ?? ap['doctor'] ?? '-').toString();
                    final time = (ap['time'] ?? ap['requested_time'] ?? '-').toString();
                    final notes = (ap['notes'] ?? ap['reason'] ?? '').toString();
                    final statusText = (ap['status'] ?? '-').toString();

                    return Column(
                      children: [
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          leading: const Icon(Icons.person_off),
                          title: Text(patient, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text('time: $time'),
                              Text('doctor: $doctor'),
                              if (notes.isNotEmpty) Text('notes: $notes'),
                            ],
                          ),
                          trailing: Text(statusText, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                          onTap: () {
                            // اختياري: فتح تفاصيل أو اعادة تفعيل الطلب
                          },
                        ),
                        if (i < ctrl.ignoredRequests.length - 1) const Divider(height: 1),
                      ],
                    );
                  }),
                ),
              ),
            );
          }),
        );
      }),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إغلاق')),
      ],
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(AppointmentsController());
  final doctorCtrl = Get.put(DoctorController());
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
           
           Row(
  children: [
    Expanded(child: Appointmentheader()),

    const SizedBox(width: 12),

    // أزرار صغيرة مخصّصة (Today, Ignored, Add Patient)
    Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton.icon(
          onPressed: () async {
            final ctrl = Get.find<AppointmentsController>();
            try {
              await ctrl.loadToday();
              _showTodayDialog(context, ctrl);
            } catch (e, st) {
              print('[UI] loadToday exception: $e\n$st');
              Get.snackbar('Error', 'Failed to fetch today appointments');
            }
          },
          icon: const Icon(Icons.today, size: 18),
          label: const Text('Today', style: TextStyle(fontSize: 13)),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(90, 36),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            backgroundColor: Colors.teal,
          ),
        ),

        const SizedBox(width: 8),

        ElevatedButton.icon(
          onPressed: () async {
            final ctrl = Get.find<AppointmentsController>();
            try {
              await ctrl.loadIgnored(); 
              _showIgnoredDialog(context, ctrl);
            } catch (e, st) {
              print('[UI] loadIgnored exception: $e\n$st');
              Get.snackbar('Error', 'Failed to fetch ignored appointments');
            }
          },
          icon: const Icon(Icons.visibility_off, size: 18),
          label: const Text('Ignored', style: TextStyle(fontSize: 13)),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(90, 36),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            backgroundColor: Colors.grey[700],
          ),
        ),

        const SizedBox(width: 8),

        
        
          
        
      ],
    ),
  ],
),

            const SizedBox(height: 16),

            Obx(() {
              return HandlingDataView(
                statusRequest: ctrl.status.value,
                widget: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _StatusCard(
                      count: ctrl.stats.value?.confirmed ?? 0,
                      label: 'Confirmed',
                      color: Colors.green[100]!,
                    ),
                    _StatusCard(
                      count: ctrl.stats.value?.pending ?? 0,
                      label: 'Waiting',
                      color: const Color(0xFFFFF3E0),
                    ),
                    _StatusCard(
                      count: ctrl.stats.value?.complete ?? 0,
                      label: 'Complete',
                      color: Colors.blue[100]!,
                    ),
                    _StatusCard(
                      count: ctrl.stats.value?.cancelled ?? 0,
                      label: 'Cancelled',
                      color: const Color(0xFFF3E5F5),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 16),

            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Day schedules ${DateFormat('yyyy/MM/dd').format(selectedDate)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 8),

            Expanded(
              child: Obx(() {
                if (ctrl.status.value != StatusRequest.success) {
                  return HandlingDataView(
                    statusRequest: ctrl.status.value,
                    widget: const SizedBox.shrink(),
                  );
                }
                if (ctrl.requests.isEmpty) {
                  return const Center(child: Text('No appointment requests.'));
                }
                return ListView.separated(
                  itemCount: ctrl.requests.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (ctx, i) {
                    final ap = ctrl.requests[i];
                 
                    final date = ap['requested_date'] as String? ?? '-';
                    final time = ap['requested_time'] as String? ?? '-';
                    final patient = ap['patient_name'] as String? ?? '-';
                    final phone = ap['patient_phone'] as String? ?? '-';
                    final doctor = ap['doctor_name'] as String? ?? '-';
                    final center = ap['center_name'] as String? ?? '-';
                    final specialty = ap['specialty'] as String? ?? '-';
                    final notes = ap['notes'] as String? ?? '-';
                    final rawStatus =
                        (ap['status'] as String? ?? '').toLowerCase();

                    
                    Color bgColor;
                    switch (rawStatus) {
                      case 'approved':
                      case 'confirmed':
                        bgColor = Colors.green[50]!;
                        break;
                      case 'pending':
                        bgColor = Colors.orange[50]!;
                        break;
                      case 'complete':
                        bgColor = Colors.blue[50]!;
                        break;
                      case 'rejected':
                      case 'cancelled':
                        bgColor = Colors.grey[200]!;
                        break;
                      default:
                        bgColor = Colors.white;
                    }

                    return Card(
                      color: bgColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                          
                            Row(
                              children: [
                                Text(
                                  date,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  time,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),

                            
                            Text('Patient: $patient'),
                            Text('Phone: $phone'),
                            Text('Doctor: $doctor'),
                            Text('Center: $center'),
                            if (specialty.isNotEmpty)
                              Text('Specialty: $specialty'),
                            if (notes.isNotEmpty) Text('Notes: $notes'),
                            const SizedBox(height: 8),

                      
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      (rawStatus == 'approved' ||
                                              rawStatus == 'confirmed')
                                          ? Icons.check_circle
                                          : Icons.hourglass_empty,
                                      color:
                                          (rawStatus == 'approved' ||
                                                  rawStatus == 'confirmed')
                                              ? Colors.green
                                              : Colors.orange,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(ap['status'] as String? ?? ''),
                                  ],
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                       onPressed: () {
    final id = ap['id'] as int;
    print('🗑  Delete appointment ID=$id');
    ctrl.removeAppointment(id); 
  },
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.orange,
                                      ),
                                      onPressed: () {
     _showEditDialog(context, ctrl, ap);
  
    // Get.to(() => EditAppointmentPage(appointment: ap));
  },
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.visibility,
                                        color: Colors.blue,
                                      ),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (_) {
                                            final id =
                                                ap['id']
                                                    as int; 
                                            print(
                                              ' Open order details by ID: $id',
                                            );
                                            return AlertDialog(
                                              title: const Text(
                                                " Appointment details",
                                                textAlign: TextAlign.center,
                                              ),
                                              content: SizedBox(
                                                width:
                                                    MediaQuery.of(
                                                      context,
                                                    ).size.width *
                                                    0.45, 
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      _buildDetailRow(
                                                        " patient name",
                                                        ap['patient_name'],
                                                      ),
                                                      _buildDetailRow(
                                                        " phone number",
                                                        ap['patient_phone'],
                                                      ),
                                                      _buildDetailRow(
                                                        "doctor",
                                                        ap['doctor_name'],
                                                      ),
                                                      _buildDetailRow(
                                                        "specialty",
                                                        ap['specialty'],
                                                      ),
                                                      _buildDetailRow(
                                                        "center",
                                                        ap['center_name'],
                                                      ),
                                                      _buildDetailRow(
                                                        "date",
                                                        ap['requested_date'],
                                                      ),
                                                      _buildDetailRow(
                                                        "time",
                                                        ap['requested_time'],
                                                      ),
                                                      _buildDetailRow(
                                                        "status",
                                                        ap['status'],
                                                      ),
                                                      if ((ap['notes'] ?? '')
                                                          .toString()
                                                          .isNotEmpty)
                                                        _buildDetailRow(
                                                          "notes",
                                                          ap['notes'],
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                              ),

                                              actions: [
                                             
                                                TextButton(
                                                  onPressed:
                                                      () => Navigator.pop(
                                                        context,
                                                      ),
                                                  child: const Text("close"),
                                                ),
                                             
                                                if ((ap['status']
                                                            ?.toString()
                                                            .toLowerCase() ??
                                                        '') ==
                                                    'pending') ...[
                                                  TextButton(
                                                    onPressed:
                                                        () { print(' I clicked Approve on the request id=$id'); ctrl.approve(id);},
                                                    style: TextButton.styleFrom(
                                                      backgroundColor:
                                                          Colors.indigo, 
                                                      foregroundColor:
                                                          Colors.white,
                                                    ),
                                                    child: const Text(
                                                      "Approve",
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      print(
                                                        ' I clicked on the request id=$id',
                                                      );
                                                      ctrl.reject(id);
                                                    },
                                                    style: TextButton.styleFrom(
                                                      backgroundColor:
                                                          Colors.grey,
                                                      foregroundColor:
                                                          Colors.white,
                                                    ),
                                                    child: const Text("Reject"),
                                                  ),
                                                ],
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
void _showEditDialog(BuildContext context, AppointmentsController ctrl, Map<String, dynamic> ap) {
  final appointmentId = ap['id'] as int;

  final DoctorController doctorCtrl = Get.isRegistered<DoctorController>()
      ? Get.find<DoctorController>()
      : Get.put(DoctorController());

  final PatientsController patientCtrl = Get.isRegistered<PatientsController>()
      ? Get.find<PatientsController>()
      : Get.put(PatientsController());

  if (doctorCtrl.doctors.isEmpty) doctorCtrl.loadDoctors();
  if (patientCtrl.patients.isEmpty) patientCtrl.getPatients();

  // patientId must remain what came with the appointment (we don't change it here)
  final int? originalPatientId = ap['patient_id'] is int
      ? ap['patient_id'] as int
      : (ap['patient_id'] != null ? int.tryParse(ap['patient_id'].toString()) : null);

  // init doctor
  int? selectedDoctorId;
  try {
    final d = ap['doctor_id'];
    selectedDoctorId = d is int ? d : (d != null ? int.tryParse(d.toString()) : null);
  } catch (_) {
    selectedDoctorId = null;
  }

  // init date & time from appointment if present
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  try {
    final rawDate = (ap['appointment_date'] ?? ap['requested_date'] ?? '').toString();
    if (rawDate.isNotEmpty) {
      final parsed = DateTime.tryParse(rawDate);
      if (parsed != null) {
        selectedDate = DateTime(parsed.year, parsed.month, parsed.day);
        selectedTime = TimeOfDay(hour: parsed.hour, minute: parsed.minute);
      }
    }
  } catch (_) {
    selectedDate = null;
    selectedTime = null;
  }

  // status must come from appointment (but we only allow approved/rejected in the UI)
  String currentStatus = (ap['status'] ?? '').toString().toLowerCase();
  if (currentStatus.isEmpty) currentStatus = 'approved'; // default if nothing

  final notesCtrl = TextEditingController(text: ap['notes']?.toString() ?? '');

  showDialog(
    context: context,
    builder: (_) {
      return StatefulBuilder(builder: (context, setState) {
        final docs = doctorCtrl.doctors;

        // allowed statuses shown in dropdown (ensure currentStatus included)
        final allowed = <String>{};
        if (currentStatus.isNotEmpty) allowed.add(currentStatus);
        allowed.add('approved');
        allowed.add('rejected');
        final statusItems = allowed.toList();

        return AlertDialog(
          title: const Text('Modify the appointment'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // --- Doctor selector
                docs.isEmpty
                    ? const SizedBox(height: 60, child: Center(child: CircularProgressIndicator()))
                    : DropdownButtonFormField<int>(
                        decoration: const InputDecoration(labelText: 'Doctor'),
                        value: selectedDoctorId,
                        items: docs.map<DropdownMenuItem<int>>((d) =>
                            DropdownMenuItem<int>(value: d.id, child: Text(d.fullName))).toList(),
                        onChanged: (v) => setState(() => selectedDoctorId = v),
                      ),

                const SizedBox(height: 8),

                // --- Date picker
                TextFormField(
                  readOnly: true,
                  decoration: const InputDecoration(labelText: 'Date'),
                  controller: TextEditingController(
                    text: selectedDate == null ? '' : DateFormat('yyyy-MM-dd').format(selectedDate!),
                  ),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate ?? DateTime.now(),
                      firstDate: DateTime.now().subtract(const Duration(days: 365 * 5)),
                      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
                    );
                    if (picked != null) setState(() => selectedDate = picked);
                  },
                ),

                const SizedBox(height: 8),

                // --- Time picker
                TextFormField(
                  readOnly: true,
                  decoration: const InputDecoration(labelText: 'Time'),
                  controller: TextEditingController(
                    text: selectedTime == null ? '' : selectedTime!.format(context),
                  ),
                  onTap: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: selectedTime ?? TimeOfDay.now(),
                    );
                    if (picked != null) setState(() => selectedTime = picked);
                  },
                ),

                const SizedBox(height: 8),

                // --- Status (only approved / rejected, default from appointment)
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Status'),
                  value: statusItems.contains(currentStatus) ? currentStatus : statusItems.first,
                  items: statusItems.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                  onChanged: (v) => setState(() => currentStatus = v ?? currentStatus),
                ),

                const SizedBox(height: 8),

                // --- Notes
                TextField(controller: notesCtrl, maxLines: 3, decoration: const InputDecoration(labelText: 'Notes')),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
             // داخل ElevatedButton onPressed:
onPressed: () async {
  // validation: only date,time,doctor,status required (patient kept original)
  if (selectedDoctorId == null) {
    Get.snackbar('Error', 'Please select a doctor');
    return;
  }
  if (selectedDate == null) {
    Get.snackbar('Error', 'Please select a date');
    return;
  }
  if (selectedTime == null) {
    Get.snackbar('Error', 'Please select a time');
    return;
  }
  if (currentStatus.isEmpty) {
    Get.snackbar('Error', 'Please select status');
    return;
  }
  if (originalPatientId == null) {
    Get.snackbar('Error', 'Original patient id missing');
    return;
  }

  // combine date + time
  final combined = DateTime(
    selectedDate!.year,
    selectedDate!.month,
    selectedDate!.day,
    selectedTime!.hour,
    selectedTime!.minute,
  );

  // format exactly as backend expects
  final dateTimeStr = DateFormat('yyyy-MM-dd HH:mm:ss').format(combined);

  // final body (patient_id kept as originalPatientId, status is the selected status)
  final requestBody = {
    'doctor_id': selectedDoctorId!,         // <-- non-null asserted
    'requested_date': dateTimeStr,
    'patient_id': originalPatientId!,      // <-- non-null asserted
    'status': currentStatus,
    if (notesCtrl.text.isNotEmpty) 'notes': notesCtrl.text,
  };

  // debug print
  print('[UI] update appointment body: $requestBody');

  // determine attendanceStatus to send (use existing appointment value or default)
  final attendanceToSend = (ap['attendance_status']?.toString() ?? 'present');

  // call controller update (controller -> datasource will send body)
  await ctrl.updateAppointment(
    id: appointmentId,
    doctorId: selectedDoctorId!,                 // <-- non-null asserted here too
    appointmentDate: dateTimeStr,
    apptStatus: currentStatus,
    attendanceStatus: attendanceToSend,         // must be non-null String
    notes: notesCtrl.text.isEmpty ? null : notesCtrl.text,
    patientId: originalPatientId!,              // <-- non-null asserted
  );

  Navigator.pop(context);
},

              child: const Text('Save'),
            ),
          ],
        );
      });
    },
  );
}



  Widget _buildDetailRow(String title, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$title: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value?.toString() ?? "-")),
        ],
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final int count;
  final String label;
  final Color color;
  const _StatusCard({
    required this.count,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        color: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            children: [
              Text(
                '$count',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(label, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
  
}
