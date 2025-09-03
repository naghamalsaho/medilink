import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:medilink/api_link.dart';

class UsersController extends GetxController {
  var users = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  final String token = "uj8b7iZ164ZSMxiyQmPnW04odaij0gNCxj8sjr1kf01f0552";

  Future<void> fetchUsers() async {
    isLoading.value = true;
    try {
      final response = await http.get(
        Uri.parse("${AppLink.server}/superadmin/users"),
        headers: {"Authorization": "Bearer $token"},
      );
      if (response.statusCode == 200) {
        users.value = List<Map<String, dynamic>>.from(
          json.decode(response.body)["data"],
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleUserStatus(int id) async {
    final response = await http.post(
      Uri.parse("${AppLink.toggleUserStatus}/$id/toggle-status"),
      headers: {"Authorization": "Bearer $token"},
    );
    if (response.statusCode == 200) {
      await fetchUsers();
    }
  }

  Future<void> assignRole(int id, String role) async {
    final response = await http.post(
      Uri.parse("${AppLink.assignUserRole}/$id/assign-role"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: json.encode({"role": role}),
    );
    if (response.statusCode == 200) {
      await fetchUsers();
    }
  }

  @override
  void onInit() {
    fetchUsers();
    super.onInit();
  }
}
