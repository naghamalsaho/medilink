import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:medilink/api_link.dart';
import 'package:get_storage/get_storage.dart';

class SuperAdminReportsController extends GetxController {
  var reportsList = <Map<String, dynamic>>[].obs; // كل التقارير
  var filteredReports = <Map<String, dynamic>>[].obs; // بعد البحث والفلترة
  var isLoading = true.obs;
  var sortAscending = true.obs; // ترتيب حسب التاريخ
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    fetchReports();
  }

  Future<void> fetchReports() async {
    isLoading.value = true;
    String? token = box.read('token');

    if (token == null) {
      Get.snackbar('Error', 'No token found, please login again');
      isLoading.value = false;
      return;
    }

    try {
      var response = await http.get(
        Uri.parse(AppLink.superAdminReports),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        reportsList.value = List<Map<String, dynamic>>.from(jsonData['data']);
        filteredReports.value = List.from(reportsList);
      } else {
        Get.snackbar('Error', 'Failed to load reports');
      }
    } catch (e) {
      Get.snackbar('Exception', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<Map<String, dynamic>?> fetchReportDetails(int reportId) async {
    String? token = box.read('token');

    if (token == null) {
      Get.snackbar('Error', 'No token found, please login again');
      return null;
    }

    try {
      var response = await http.get(
        Uri.parse(AppLink.superAdminReportById(reportId)),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        return Map<String, dynamic>.from(jsonData['data']);
      } else if (response.statusCode == 404) {
        Get.snackbar('Error', 'Report not found');
        return null;
      } else {
        Get.snackbar('Error', 'Failed to load report details');
        return null;
      }
    } catch (e) {
      Get.snackbar('Exception', e.toString());
      return null;
    }
  }

  // فلترة البحث
  void filterReports(String query) {
    if (query.isEmpty) {
      filteredReports.value = List.from(reportsList);
    } else {
      filteredReports.value =
          reportsList
              .where(
                (r) =>
                    r['id'].toString().contains(query) ||
                    (r['message'] ?? '').toLowerCase().contains(
                      query.toLowerCase(),
                    ),
              )
              .toList();
    }
  }

  // ترتيب حسب التاريخ
  void sortReports(bool ascending) {
    sortAscending.value = ascending;
    filteredReports.sort((a, b) {
      DateTime dateA =
          DateTime.tryParse(a['created_at'] ?? '') ?? DateTime.now();
      DateTime dateB =
          DateTime.tryParse(b['created_at'] ?? '') ?? DateTime.now();
      return ascending ? dateA.compareTo(dateB) : dateB.compareTo(dateA);
    });
    filteredReports.refresh();
  }
}
