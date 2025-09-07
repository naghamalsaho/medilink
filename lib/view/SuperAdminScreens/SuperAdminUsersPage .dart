import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink/controller/SuperAdminController/UsersController%20.dart';

class UsersManagementPage extends StatelessWidget {
  UsersManagementPage({super.key});
  final controller = Get.put(UsersController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Users Management",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Obx(() {
                if (controller.users.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: constraints.maxWidth,
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: SizedBox(
                                width: constraints.maxWidth,
                                child: DataTable(
                                  columnSpacing: 24,
                                  headingRowColor: MaterialStateProperty.all(
                                    const Color(0xFFF3F4F6),
                                  ),
                                  columns: const [
                                    DataColumn(label: Text("Name")),
                                    DataColumn(label: Text("Email")),
                                    DataColumn(label: Text("Status")),
                                  ],
                                  rows:
                                      controller.users.map((user) {
                                        return DataRow(
                                          cells: [
                                            DataCell(Text(user["name"] ?? "")),
                                            DataCell(Text(user["email"] ?? "")),
                                            DataCell(
                                              Switch(
                                                value: user["status"] ?? false,
                                                onChanged: (val) async {
                                                  await controller.toggleStatus(
                                                    user["id"],
                                                    val,
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        );
                                      }).toList(),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
