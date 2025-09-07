import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:medilink/api_link.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

// ================= Controller =================
class ReportsControllerSecretary extends GetxController {
  var isLoading = true.obs;

  // البيانات
  var appointmentsTrend = <TrendDataSecretary>[].obs;
  var summary = SummarySecretary().obs;
  var kpi = KPISecretary().obs;

  var schedule = <AppointmentSecretary>[].obs;
  var newPatients = <NewPatientSecretary>[].obs;

  DateTime startDate = DateTime.now().subtract(const Duration(days: 7));
  DateTime endDate = DateTime.now();

  final chartKey = GlobalKey();

  @override
  void onInit() {
    fetchReports(scope: "week");
    super.onInit();
  }

  void fetchReports({
    String scope = "week",
    DateTime? from,
    DateTime? to,
  }) async {
    try {
      isLoading(true);
      String url = "";
      if (scope == "week") {
        url = AppLink.secretaryReportWeek();
      } else if (scope == "day") {
        url = AppLink.secretaryReportDay();
      } else if (scope == "custom" && from != null && to != null) {
        url = AppLink.secretaryReportCustom(
          from: from.toIso8601String().split("T").first,
          to: to.toIso8601String().split("T").first,
        );
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer ${AppLink.token}'},
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body)['data'];

        // تحويل schedule
        schedule.value = List<AppointmentSecretary>.from(
          data['schedule'].map((x) => AppointmentSecretary.fromJson(x)),
        );

        // trend للchart
        appointmentsTrend.value = List<TrendDataSecretary>.from(
          data['schedule'].map(
            (x) => TrendDataSecretary(
              date: x['date'],
              newRequests: 1,
              completed: x['attendance_status'] == "present" ? 1 : 0,
            ),
          ),
        );

        // Summary
        summary.value = SummarySecretary(
          total: data['summary']['total_appointments'],
          attended: data['summary']['attended'],
          absent: data['summary']['absent'],
        );

        kpi.value = KPISecretary(
          attendanceRate: data['summary']['attendance_rate'],
        );

        // المرضى الجدد
        newPatients.value = List<NewPatientSecretary>.from(
          data['new_patients'].map((x) => NewPatientSecretary.fromJson(x)),
        );
      } else {
        print("Error fetching secretary reports: ${response.body}");
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<Uint8List?> captureWidget(GlobalKey key) async {
    try {
      RenderRepaintBoundary boundary =
          key.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      print('Error capturing widget: $e');
      return null;
    }
  }

  void exportPDF() async {
    final pdf = pw.Document();
    final chartImage = await captureWidget(chartKey);

    pdf.addPage(
      pw.MultiPage(
        build:
            (context) => [
              pw.Header(level: 0, text: 'Secretary Report'),
              if (chartImage != null)
                pw.Image(pw.MemoryImage(chartImage), height: 250),
              pw.SizedBox(height: 20),

              // Summary
              pw.Paragraph(text: 'Appointments Summary'),
              pw.Table.fromTextArray(
                headers: ['Type', 'Count'],
                data: [
                  ['Total', summary.value.total],
                  ['Attended', summary.value.attended],
                  ['Absent', summary.value.absent],
                  ['Attendance Rate', '${kpi.value.attendanceRate}%'],
                ],
              ),

              pw.SizedBox(height: 20),

              // Schedule
              pw.Paragraph(text: 'Appointments Schedule'),
              pw.Table.fromTextArray(
                headers: [
                  'ID',
                  'Patient',
                  'Doctor',
                  'Date',
                  'Time',
                  'Status',
                  'Attendance',
                ],
                data:
                    schedule
                        .map(
                          (s) => [
                            s.id,
                            s.patientName,
                            s.doctorName,
                            s.date,
                            s.time,
                            s.status,
                            s.attendanceStatus,
                          ],
                        )
                        .toList(),
              ),

              pw.SizedBox(height: 20),

              // New Patients
              pw.Paragraph(text: 'New Patients'),
              pw.Table.fromTextArray(
                headers: ['ID', 'Name', 'Phone', 'Email', 'Joined At'],
                data:
                    newPatients
                        .map(
                          (p) => [
                            p.id,
                            p.name,
                            p.phone ?? '-',
                            p.email ?? '-',
                            p.joinedAt ?? '-',
                          ],
                        )
                        .toList(),
              ),
            ],
      ),
    );

    await Printing.layoutPdf(onLayout: (format) => pdf.save());
  }
}

// ================= Models =================
class AppointmentSecretary {
  int id;
  String patientName;
  String doctorName;
  String date;
  String time;
  String status;
  String attendanceStatus;

  AppointmentSecretary({
    required this.id,
    required this.patientName,
    required this.doctorName,
    required this.date,
    required this.time,
    required this.status,
    required this.attendanceStatus,
  });

  factory AppointmentSecretary.fromJson(Map<String, dynamic> json) {
    return AppointmentSecretary(
      id: json['appointment_id'],
      patientName: json['patient_name'],
      doctorName: json['doctor_name'],
      date: json['date'],
      time: json['time'],
      status: json['status'],
      attendanceStatus: json['attendance_status'],
    );
  }
}

class TrendDataSecretary {
  String date;
  int newRequests;
  int completed;

  TrendDataSecretary({
    required this.date,
    required this.newRequests,
    required this.completed,
  });
}

class SummarySecretary {
  int total;
  int attended;
  int absent;

  SummarySecretary({this.total = 0, this.attended = 0, this.absent = 0});
}

class NewPatientSecretary {
  int id;
  String name;
  String? phone;
  String? email;
  String? joinedAt;

  NewPatientSecretary({
    required this.id,
    required this.name,
    this.phone,
    this.email,
    this.joinedAt,
  });

  factory NewPatientSecretary.fromJson(Map<String, dynamic> json) {
    return NewPatientSecretary(
      id: json['user_id'],
      name: json['full_name'],
      phone: json['phone'],
      email: json['email'],
      joinedAt: json['joined_at'],
    );
  }
}

class KPISecretary {
  int attendanceRate;

  KPISecretary({this.attendanceRate = 0});
}
