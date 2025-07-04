import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medilink/view/widget/NewAppointmentDialog.dart'; // لـ DateFormat
// افترض أنك عرفت الألوان في AppColor

class AppointmentsPage extends StatefulWidget {
  @override
  _AppointmentsPageState createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  DateTime selectedDate = DateTime.now();
  String selectedStatus = 'جميع الحالات';
  final statuses = ['جميع الحالات', 'مؤكد', 'في الانتظار', 'مكتمل', 'ملغي'];
  final searchController = TextEditingController();

  // مثال بيانات
  final appointments = [
    {
      'time': '09:00',
      'name': 'أحمد محمد علي',
      'doctor': 'د. سامي الأحمد',
      'specialty': 'كشف دوري',
      'duration': '30 دقيقة',
      'status': 'مؤكد',
      'color': Color(0xFFD4F7DC),
    },
    {
      'time': '09:30',
      'name': 'فاطمة سعد الغامدي',
      'doctor': 'د. ليلى حسن',
      'specialty': 'متابعة نتائج التحاليل',
      'duration': '30 دقيقة',
      'status': 'في الانتظار',
      'color': Color(0xFFFFF2CC),
    },
    // المزيد...
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('إدارة المواعيد', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          TextButton.icon(
  icon: const Icon(Icons.add, color: Colors.white),
  label: const Text('إضافة موعد جديد', style: TextStyle(color: Colors.white)),
  onPressed: () {
    showDialog(
      context: context,
      builder: (_) => const NewAppointmentDialog(),
    );
  },
)

        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // فلاتر التاريخ والبحث والحالة
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
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
                      items: statuses
                          .map((s) => DropdownMenuItem(child: Text(s), value: s))
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
                          hintText: 'البحث بالاسم، الطبيب، أو السبب...',
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
                _StatusCard(count: 2, label: 'مواعيد مؤكدة', color: Colors.green[100]!),
                _StatusCard(count: 1, label: 'في الانتظار', color: Colors.orange[100]!),
                _StatusCard(count: 1, label: 'مكتملة', color: Colors.blue[100]!),
                _StatusCard(count: 1, label: 'ملغية', color: Colors.red[100]!),
              ],
            ),

            const SizedBox(height: 16),
            // عنوان التاريخ الهجري/الميلادي
            Align(
              alignment: Alignment.centerRight,
              child: Text('مواعيد يوم ${DateFormat('yyyy/MM/dd').format(selectedDate)} هـ',
                  style: TextStyle(fontWeight: FontWeight.bold)),
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
                        borderRadius: BorderRadius.circular(12)),
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
                            child: Text(ap['time'] as String,
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),

                          const SizedBox(width: 16),
                          // التفاصيل
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(ap['name'] as String,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Text(ap['doctor'] as String),
                                Text(ap['specialty'] as String,
                                    style: TextStyle(color: Colors.blue)),
                                Text('المدة: ${ap['duration']}',
                                    style: TextStyle(color: Colors.grey)),
                              ],
                            ),
                          ),

                          // الحالة
                          Column(
                            children: [
                              Icon(
                                ap['status'] == 'مؤكد'
                                    ? Icons.check_circle
                                    : Icons.hourglass_empty,
                                color: ap['status'] == 'مؤكد'
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
                                  onPressed: () {}),
                              IconButton(
                                  icon: Icon(Icons.edit, color: Colors.orange),
                                  onPressed: () {}),
                              IconButton(
                                  icon: Icon(Icons.visibility, color: Colors.blue),
                                  onPressed: () {}),
                            ],
                          )
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
  const _StatusCard(
      {required this.count, required this.label, required this.color});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        color: color,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            children: [
              Text('$count', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(label, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
