import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UsersManagementPage extends StatelessWidget {
  UsersManagementPage({super.key});

  final RxList<Map<String, dynamic>> users =
      <Map<String, dynamic>>[
        {
          "id": 1,
          "name": "John Doe",
          "email": "john@example.com",
          "status": true,
          "role": "doctor",
        },
        {
          "id": 2,
          "name": "Sarah Smith",
          "email": "sarah@example.com",
          "status": false,
          "role": "secretary",
        },
      ].obs;

  final roles = ["doctor", "secretary", "admin", "superadmin"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // العنوان
            const Text(
              "Users Management",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 24),

            // الجدول بكرت كامل العرض
            Expanded(
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Obx(() {
                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SizedBox(
                        width: double.infinity, // <<< ياخد عرض الصفحة كامل
                        child: DataTable(
                          headingRowColor: WidgetStateProperty.all(
                            const Color(0xFFF3F4F6),
                          ),
                          columnSpacing: 24,
                          border: TableBorder.all(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          columns: const [
                            DataColumn(label: Text("Name")),
                            DataColumn(label: Text("Email")),
                            DataColumn(label: Text("Status")),
                            DataColumn(label: Text("Role")),
                            DataColumn(label: Text("Actions")),
                          ],
                          rows:
                              users.map((user) {
                                return DataRow(
                                  cells: [
                                    DataCell(Text(user["name"])),
                                    DataCell(Text(user["email"])),
                                    DataCell(
                                      Switch(
                                        value: user["status"],
                                        onChanged: (val) {
                                          user["status"] = val;
                                          users.refresh();
                                        },
                                      ),
                                    ),
                                    DataCell(Text(user["role"])),
                                    DataCell(
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(
                                              Icons.edit,
                                              color: Colors.blue,
                                            ),
                                            onPressed: () {},
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                            onPressed: () {},
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
