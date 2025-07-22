import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medilink/view/widget/NewAppointmentDialog.dart';
import 'package:medilink/view/widget/appointmentHeader.dart'; // لـ DateFormat
// افترض أنك عرفت الألوان في AppColor

class AppointmentsPage extends StatefulWidget {
  @override
  _AppointmentsPageState createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  DateTime selectedDate = DateTime.now();
  String selectedStatus = 'All status';
  final statuses = [
    'All status',
    'confirmed',
    'Waiting',
    'Complete',
    'Cancelled',
  ];
  final searchController = TextEditingController();

  // مثال بيانات
  final appointments = [
    {
      'time': '09:00',
      'name': 'Ahmad ali ',
      'doctor': 'D. sami ',
      'specialty': 'Periodic report',
      'duration': '30 minute',
      'status': 'confirmed',
      'color': Color(0xFFD4F7DC),
    },
    {
      'time': '09:30',
      'name': 'Asmaa mom',
      'doctor': 'D. sami',
      'specialty': 'Monitoring the test results',
      'duration': '30 minute',
      'status': 'Waiting',
      'color': Color(0xFFFFF2CC),
    },
    // المزيد...
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Appointmentheader(),
            SizedBox(height: 16),

            // فلاتر التاريخ والبحث والحالة
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                child: Row(
                  children: [
                    // التاريخ
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          final dt = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (dt != null) setState(() => selectedDate = dt);
                        },
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today, color: Colors.grey[700]),
                            const SizedBox(width: 4),
                            Text(DateFormat('MM/dd/yyyy').format(selectedDate)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // الحالة
                    DropdownButton<String>(
                      value: selectedStatus,
                      items:
                          statuses
                              .map(
                                (s) =>
                                    DropdownMenuItem(child: Text(s), value: s),
                              )
                              .toList(),
                      onChanged: (v) => setState(() => selectedStatus = v!),
                    ),
                    const SizedBox(width: 16),
                    // البحث
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          hintText: 'Search by name, doctor or condition.....',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          isDense: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),
            // ملخص الحالات
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _StatusCard(
                  count: 2,
                  label: 'confirmed',
                  color: Colors.green[100]!,
                ),
                _StatusCard(
                  count: 1,
                  label: 'Waiting',
                  color: Color(0xFFFFF3E0),
                ),
                _StatusCard(
                  count: 1,
                  label: 'Complete',
                  color: Colors.blue[100]!,
                ),
                _StatusCard(
                  count: 1,
                  label: 'Cancelled',
                  color: Color(0xFFF3E5F5),
                ),
              ],
            ),

            const SizedBox(height: 16),
            // عنوان التاريخ الهجري/الميلادي
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Day schedules${DateFormat('yyyy/MM/dd').format(selectedDate)} هـ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 8),
            // قائمة المواعيد
            Expanded(
              child: ListView.separated(
                itemCount: appointments.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (ctx, i) {
                  final ap = appointments[i];
                  return Card(
                    color: ap['color'] as Color,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          // الوقت
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              ap['time'] as String,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),

                          const SizedBox(width: 16),
                          // التفاصيل
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ap['name'] as String,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(ap['doctor'] as String),
                                Text(
                                  ap['specialty'] as String,
                                  style: TextStyle(color: Colors.blue),
                                ),
                                Text(
                                  'المدة: ${ap['duration']}',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),

                          // الحالة
                          Column(
                            children: [
                              Icon(
                                ap['status'] == 'confirmed'
                                    ? Icons.check_circle
                                    : Icons.hourglass_empty,
                                color:
                                    ap['status'] == 'confirmed'
                                        ? Colors.green
                                        : Colors.orange,
                              ),
                              Text(ap['status'] as String),
                            ],
                          ),

                          const SizedBox(width: 8),
                          // أزرار الإجراءات
                          Column(
                            children: [
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.orange),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.visibility,
                                  color: Colors.blue,
                                ),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
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
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
