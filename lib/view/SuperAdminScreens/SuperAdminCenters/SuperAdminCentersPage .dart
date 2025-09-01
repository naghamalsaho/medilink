import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink/controller/SuperAdminController/SuperAdminCentersController%20.dart';

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
                  : GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          childAspectRatio: 1.8,
                        ),
                    itemCount: controller.centersList.length,
                    itemBuilder: (context, index) {
                      final center = controller.centersList[index];
                      final isActive = center['is_active'] ?? true;

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.teal.withOpacity(0.15),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.apartment,
                                          color: Colors.teal,
                                          size: 28,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        center['name'] ?? 'No Name',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
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
                                ],
                              ),
                              const SizedBox(height: 12),

                              // Info
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    size: 18,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      center['location'] ?? '-',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.phone,
                                    size: 18,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    center['phone'] ?? '-',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                              const Divider(height: 18),

                              // Counts with icons (السمايلات)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildInfoChip(
                                    "👤",
                                    "Admins",
                                    center['admin_centers_count'],
                                  ),
                                  _buildInfoChip(
                                    "📝",
                                    "Secretaries",
                                    center['secretaries_count'],
                                  ),
                                  _buildInfoChip(
                                    "🩺",
                                    "Doctors",
                                    center['doctors_count'],
                                  ),
                                ],
                              ),
                              const Spacer(),

                              // Status & Toggle
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    isActive ? "Active" : "Inactive",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color:
                                          isActive ? Colors.green : Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Switch(
                                    value: center['is_active'] == true,
                                    onChanged: (_) {
                                      controller.toggleCenterStatus(
                                        center['id'],
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildInfoChip(String emoji, String label, int? value) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 4),
        Text(
          "${value ?? 0} $label",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ],
    );
  }
}
