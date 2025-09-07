import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink/controller/SuperAdminController/SuperAdminCentersController%20.dart';
import 'package:http/http.dart' as http;
import 'package:medilink/api_link.dart';

class SuperAdminCentersPage extends StatelessWidget {
  SuperAdminCentersPage({super.key});
  final SuperAdminCentersController controller = Get.put(
    SuperAdminCentersController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 18),
              Text(
                "Medical Centers",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 16),
              controller.centersList.isEmpty
                  ? const Center(child: Text("No centers found."))
                  : Column(
                    children:
                        controller.centersList.map((center) {
                          return _buildCenterCard(center);
                        }).toList(),
                  ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildCenterCard(Map<String, dynamic> center) {
    final isActive = center['is_active'] ?? true;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // صورة المركز
            _buildCenterImage(center['image']),
            const SizedBox(width: 16),

            // معلومات المركز
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    center['name'] ?? '-',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    center['location'] ?? '-',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    center['phone'] ?? '-',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildInfoText("Admins", center['counts']?['admins']),
                      const SizedBox(width: 12),
                      _buildInfoText(
                        "Secretaries",
                        center['counts']?['secretaries'],
                      ),
                      const SizedBox(width: 12),
                      _buildInfoText("Doctors", center['counts']?['doctors']),
                    ],
                  ),
                ],
              ),
            ),

            // أزرار التعديل و التفعيل + تفاصيل
            Column(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.blueGrey,
                    size: 24,
                  ),
                  onPressed: () {
                    controller.openEditDialog(center);
                  },
                ),
                const SizedBox(height: 8),
                Switch(
                  value: isActive,
                  onChanged: (_) {
                    controller.toggleCenterStatus(center['id']);
                  },
                ),
                const SizedBox(height: 8),
                IconButton(
                  icon: const Icon(
                    Icons.info_outline,
                    color: Colors.teal,
                    size: 24,
                  ),
                  onPressed: () {
                    _showCenterDetails(center);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showCenterDetails(Map<String, dynamic> center) {
    Get.defaultDialog(
      title: "Center Details",
      titleStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.teal,
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _detailRow("Admin Name", center['admin_full_name'] ?? "-"),
          const SizedBox(height: 8),
          _detailRow(
            "Admin User ID",
            center['admin_user_id']?.toString() ?? "-",
          ),
          const SizedBox(height: 8),
          _detailRow("Phone", center['phone'] ?? "-"),
          const SizedBox(height: 8),
          _detailRow("Location", center['location'] ?? "-"),
        ],
      ),
      radius: 12,
      confirm: TextButton(
        onPressed: () => Get.back(),
        child: const Text("Close", style: TextStyle(fontSize: 16)),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Row(
      children: [
        Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
        Expanded(child: Text(value)),
      ],
    );
  }

  Widget _buildCenterImage(String? imagePath) {
    if (imagePath == null) {
      return Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.apartment, color: Colors.teal, size: 40),
      );
    } else {
      return FutureBuilder<Uint8List?>(
        future: _fetchImageBytes(imagePath),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              width: 80,
              height: 80,
              alignment: Alignment.center,
              child: const CircularProgressIndicator(strokeWidth: 2),
            );
          } else if (snapshot.hasError || snapshot.data == null) {
            return Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.apartment, color: Colors.teal, size: 40),
            );
          } else {
            return ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.memory(
                snapshot.data!,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            );
          }
        },
      );
    }
  }

  Future<Uint8List?> _fetchImageBytes(String imagePath) async {
    try {
      final url = "${AppLink.server}/storage/$imagePath";
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer ${AppLink.token}'},
      );
      if (response.statusCode == 200) {
        return response.bodyBytes;
      }
    } catch (e) {
      print("Error loading image: $e");
    }
    return null;
  }

  Widget _buildInfoText(String label, int? value) {
    return Text(
      "$label: ${value ?? 0}",
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
    );
  }
}
