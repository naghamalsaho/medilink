import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewAppointmentDialog extends StatefulWidget {
  const NewAppointmentDialog({Key? key}) : super(key: key);

  @override
  _NewAppointmentDialogState createState() => _NewAppointmentDialogState();
}

class _NewAppointmentDialogState extends State<NewAppointmentDialog> {
  String? patient;
  String? doctor;
  DateTime? date;
  TimeOfDay? time;
  String? visitType;
  final notesController = TextEditingController();

  final patients = ['أحمد', 'فاطمة', 'سارة'];
  final doctors = ['د. سامي', 'د. ليلى', 'د. علي'];
  final visitTypes = ['كشف عام', 'متابعة'];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('حجز موعد جديد'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'اسم المريض'),
              items: patients.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
              value: patient,
              onChanged: (v) => setState(() => patient = v),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'الطبيب'),
              items: doctors.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
              value: doctor,
              onChanged: (v) => setState(() => doctor = v),
            ),
            const SizedBox(height: 10),
            TextFormField(
              decoration: const InputDecoration(labelText: 'التاريخ'),
              readOnly: true,
              controller: TextEditingController(
                text: date == null ? '' : DateFormat('yyyy/MM/dd').format(date!),
              ),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: date ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) setState(() => date = picked);
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              decoration: const InputDecoration(labelText: 'الوقت'),
              readOnly: true,
              controller: TextEditingController(
                text: time == null ? '' : time!.format(context),
              ),
              onTap: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: time ?? TimeOfDay.now(),
                );
                if (picked != null) setState(() => time = picked);
              },
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'نوع الزيارة'),
              items: visitTypes.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
              value: visitType,
              onChanged: (v) => setState(() => visitType = v),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: notesController,
              decoration: const InputDecoration(labelText: 'ملاحظات'),
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
        ElevatedButton(
          onPressed: () {
            // TODO: احفظ البيانات أو مرّرها للـ Controller
            Navigator.pop(context);
          },
          child: const Text('حجز الموعد'),
        ),
      ],
    );
  }
}
