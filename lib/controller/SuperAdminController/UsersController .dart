import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:medilink/api_link.dart';

class UsersController extends GetxController {
  var users = <Map<String, dynamic>>[].obs;
  final roles = ["doctor", "secretary", "admin", "superadmin"];

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  Map<String, String> get headers => {
    "Accept": "application/json",
    "Authorization": "Bearer ${AppLink.token}",
    "Content-Type": "application/json",
  };

  Future<void> fetchUsers() async {
    try {
      final url = Uri.parse(AppLink.users);
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        users.value =
            (data['data'] as List).map((u) {
              return {
                "id": u["id"],
                "name": u["full_name"],
                "email": u["email"],
                "status": u["is_active"] ?? false,
                "role": u["roles"].isNotEmpty ? u["roles"][0] : "",
              };
            }).toList();
      } else {
        print("Error fetching users: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception fetching users: $e");
    }
  }

  Future<void> toggleStatus(int userId, bool status) async {
    try {
      final url = Uri.parse(AppLink.toggleUserStatus(userId));
      final response = await http.put(url, headers: headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final updatedUser = data["data"];
        final index = users.indexWhere((u) => u["id"] == userId);
        if (index != -1) {
          users[index]["status"] = updatedUser["is_active"] ?? false;
          users.refresh();

          // 🟢🟥 Snackbar حسب الحالة
          Get.snackbar(
            "Status Updated",
            "User is now ${users[index]["status"] ? "Active" : "Inactive"}",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor:
                users[index]["status"]
                    ? Colors.green.withOpacity(0.8)
                    : Colors.red.withOpacity(0.8),
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
        }
      } else {
        print("Error toggling status: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception toggling status: $e");
    }
  }

  Future<void> assignRole(int userId, String role) async {
    try {
      final url = Uri.parse(AppLink.assignUserRole(userId));
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode({"role": role}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final newRole = data["data"]["role"];
        final index = users.indexWhere((u) => u["id"] == userId);
        if (index != -1) {
          users[index]["role"] = newRole;
          users.refresh();

          // 🟢 Snackbar عند تغيير الصلاحية
          Get.snackbar(
            "Role Updated",
            "User role changed to $newRole",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.blue.withOpacity(0.8),
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
        }
      } else {
        print("Error assigning role: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception assigning role: $e");
    }
  }
}
