import 'dart:typed_data';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:medilink/api_link.dart';
import 'dart:convert';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;

class ReportsController extends GetxController {
  var isLoading = true.obs;
  var appointmentsTrend = <TrendData>[].obs;
  var summary = Summary().obs;
  var doctorStats = <DoctorStat>[].obs;
  var kpi = KPI().obs;

  // تاريخ البداية والنهاية
  var startDate = DateTime(2025, 8, 1).obs;
  var endDate = DateTime(2025, 9, 3).obs;

  // Key for capturing chart widget
  final chartKey = GlobalKey();

  @override
  void onInit() {
    fetchReports();
    super.onInit();
  }

  void updateDateRange(DateTime start, DateTime end) {
    startDate.value = start;
    endDate.value = end;
    fetchReports();
  }

  void fetchReports() async {
    try {
      isLoading(true);

      // Fetch trend
      final trendResponse = await http.get(
        Uri.parse(AppLink.appointmentsTrend(startDate.value, endDate.value)),
        headers: {'Authorization': 'Bearer ${AppLink.token}'},
      );

      if (trendResponse.statusCode == 200) {
        var data = json.decode(trendResponse.body)['data'];
        appointmentsTrend.value = List<TrendData>.from(
          data.map((x) => TrendData.fromJson(x)),
        );
      }

      final detailedResponse = await http.get(
        Uri.parse(AppLink.centerDetailed(startDate.value, endDate.value)),
        headers: {'Authorization': 'Bearer ${AppLink.token}'},
      );

      if (detailedResponse.statusCode == 200) {
        var data = json.decode(detailedResponse.body)['data'];
        summary.value = Summary.fromJson(data['summary']);
        doctorStats.value = List<DoctorStat>.from(
          data['doctor_stats'].map((x) => DoctorStat.fromJson(x)),
        );
        kpi.value = KPI.fromJson(data['kpi']);
      } else {
        print('Detailed Error: ${detailedResponse.body}');
      }
    } catch (e) {
      print('Error fetching reports: $e');
    } finally {
      isLoading(false);
    }
  }

  // Capture Widget as Image
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

  // Export PDF including chart and cards
  void exportPDF() async {
    final pdf = pw.Document();

    final chartImage = await captureWidget(chartKey);

    pdf.addPage(
      pw.MultiPage(
        build:
            (context) => [
              pw.Header(level: 0, text: 'Center Report'),
              if (chartImage != null)
                pw.Image(pw.MemoryImage(chartImage), height: 250),
              pw.SizedBox(height: 20),
              pw.Paragraph(text: 'Appointments Summary'),
              pw.Table.fromTextArray(
                headers: ['Type', 'Count'],
                data: [
                  ['Total', summary.value.total],
                  ['Completed', summary.value.completed],
                  ['Pending', summary.value.pending],
                  ['Approved', summary.value.approved],
                  ['Canceled', summary.value.canceled],
                  ['Attendance Rate', '${kpi.value.attendanceRate}%'],
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Paragraph(text: 'Doctor Statistics'),
              pw.Table.fromTextArray(
                headers: ['Doctor', 'Patients Count'],
                data:
                    doctorStats
                        .map((d) => [d.doctorName, d.patientsCount])
                        .toList(),
              ),
            ],
      ),
    );

    await Printing.layoutPdf(onLayout: (format) => pdf.save());
  }
}

// Models
class TrendData {
  String date;
  int newRequests;
  int completed;
  TrendData({
    required this.date,
    required this.newRequests,
    required this.completed,
  });
  factory TrendData.fromJson(Map<String, dynamic> json) => TrendData(
    date: json['date'],
    newRequests: json['new_requests'],
    completed: json['completed'],
  );
}

class Summary {
  int total, completed, pending, approved, canceled;
  Summary({
    this.total = 0,
    this.completed = 0,
    this.pending = 0,
    this.approved = 0,
    this.canceled = 0,
  });
  factory Summary.fromJson(Map<String, dynamic> json) => Summary(
    total: json['total'],
    completed: json['completed'],
    pending: json['pending'],
    approved: json['approved'],
    canceled: json['canceled'],
  );
}

class DoctorStat {
  int doctorId;
  String doctorName;
  int patientsCount;
  DoctorStat({
    required this.doctorId,
    required this.doctorName,
    required this.patientsCount,
  });
  factory DoctorStat.fromJson(Map<String, dynamic> json) => DoctorStat(
    doctorId: json['doctor_id'],
    doctorName: json['doctor_name'],
    patientsCount: json['patients_count'],
  );
}

class KPI {
  int attendanceRate;
  KPI({this.attendanceRate = 0});
  factory KPI.fromJson(Map<String, dynamic> json) =>
      KPI(attendanceRate: json['attendance_rate']);
}
