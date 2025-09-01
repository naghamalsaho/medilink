import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:medilink/api_link.dart';
import 'dart:convert';
import 'package:medilink/core/class/statusrequest.dart';
import 'package:medilink/core/services/MyServices.dart';

class ServicesController extends GetxController {
  var catalogServices = <Map<String, dynamic>>[].obs;
  var centerServices = <Map<String, dynamic>>[].obs;
  var addedServiceIds = <int>[].obs;

  var isLoading = false.obs;
  StatusRequest statusRequest = StatusRequest.none;
  late String token;

  @override
  void onInit() {
    token = Get.find<MyServices>().box.read("token") ?? "";

    if (token.isEmpty) {
      print("❌ لا يوجد توكن! يجب تسجيل الدخول أولاً");
    } else {
      print("✅ التوكن المسترجع: $token");
      fetchCatalogServices();
      fetchCenterServices(); // ✅ جلب خدمات المركز عند التحميل
    }

    super.onInit();
  }

  /// 📌 جلب كل الخدمات من الكاتالوغ
  Future<void> fetchCatalogServices() async {
    isLoading.value = true;
    statusRequest = StatusRequest.loading;
    update();

    try {
      var response = await http.get(
        Uri.parse(AppLink.catalogServices),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print("Catalog Status code: ${response.statusCode}");
      print("Catalog Response body: ${response.body}");

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        if (jsonData['success'] == true) {
          catalogServices.value = List<Map<String, dynamic>>.from(
            jsonData['data'],
          );
          print("Catalog services loaded: ${catalogServices.length}");
          statusRequest = StatusRequest.success;
        } else {
          statusRequest = StatusRequest.failure;
        }
      } else {
        statusRequest = StatusRequest.failure;
      }
    } catch (e) {
      print('Error fetching catalog services: $e');
      statusRequest = StatusRequest.failure;
    } finally {
      isLoading.value = false;
      update();
    }
  }

  /// 📌 جلب خدمات المركز
  Future<void> fetchCenterServices() async {
    try {
      var response = await http.get(
        Uri.parse(AppLink.centerServices),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print("Center Status code: ${response.statusCode}");
      print("Center Response body: ${response.body}");

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        if (jsonData['success'] == true) {
          // ⚡ ملاحظة: الخدمة جوا object اسمو "service"
          centerServices.value = List<Map<String, dynamic>>.from(
            jsonData['data'].map((item) => item['service']),
          );
          print("Center services loaded: ${centerServices.length}");
        }
      }
    } catch (e) {
      print('Error fetching center services: $e');
    }
  }

  /// 📌 إضافة خدمة للمركز
  Future<void> addServiceToCenterApi(int serviceId) async {
    if (addedServiceIds.contains(serviceId)) return; // يمنع الضغط المكرر

    try {
      var response = await http.post(
        Uri.parse(AppLink.centerServices),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"service_id": serviceId}),
      );

      var jsonData = jsonDecode(response.body);

      if (response.statusCode == 200 && jsonData['success'] == true) {
        addedServiceIds.add(serviceId); // ✅ نعلّم الخدمة كمضافة
        fetchCenterServices(); // تحديث قائمة المركز
        Get.dialog(
          Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 60),
                  const SizedBox(height: 16),
                  Text(
                    jsonData['message'] ?? "Service added successfully",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => Get.back(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("تم"),
                  ),
                ],
              ),
            ),
          ),
        );
      } else {
        Get.snackbar("خطأ", jsonData['message'] ?? "فشل إضافة الخدمة");
      }
    } catch (e) {
      Get.snackbar("خطأ", "حصل خطأ أثناء الاتصال بالسيرفر");
    }
  }

  /// 📌 إزالة خدمة محلياً
  void removeFromCenter(Map<String, dynamic> service) {
    centerServices.remove(service);
  }

  // حذف خدمة
  Future<void> removeServiceFromCenterApi(int serviceId) async {
    try {
      var response = await http.delete(
        Uri.parse("${AppLink.centerServices}/$serviceId"),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      var jsonData = jsonDecode(response.body);

      if (response.statusCode == 200 && jsonData['success'] == true) {
        addedServiceIds.remove(serviceId);
        centerServices.removeWhere((s) => s['id'] == serviceId);
        Get.snackbar("نجاح", jsonData['message'] ?? "تم الحذف");
      } else {
        Get.snackbar("خطأ", jsonData['message'] ?? "فشل الحذف");
      }
    } catch (e) {
      Get.snackbar("خطأ", "حصل خطأ أثناء الاتصال بالسيرفر");
    }
  }
}
