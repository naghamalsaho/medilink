import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink/controller/SuperAdminController/ReportsController%20.dart';

class SuperAdminReportsPage extends StatelessWidget {
  final SuperAdminReportsController controller = Get.put(
    SuperAdminReportsController(),
  );
  final TextEditingController searchController = TextEditingController();

  SuperAdminReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // العنوان
              const Padding(
                padding: EdgeInsets.only(bottom: 16.0),
                child: Text(
                  'Reports Management',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),

              // شريط البحث
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search reports...',
                  prefixIcon: const Icon(Icons.search),
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  controller.filterReports(value);
                },
              ),

              const SizedBox(height: 16),

              // قائمة التقارير
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.reportsList.isEmpty) {
                    return const Center(
                      child: Text(
                        'No reports available.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: controller.reportsList.length,
                    itemBuilder: (context, index) {
                      var report = controller.reportsList[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          title: Text(
                            'Report ID: ${report['id']}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 6.0),
                            child: Text(
                              report['message'] ?? '-',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 18,
                          ),
                          onTap: () async {
                            var details = await controller.fetchReportDetails(
                              report['id'],
                            );
                            if (details != null) {
                              Get.defaultDialog(
                                title: 'Report Details',
                                titleStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                                content: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('ID: ${details['id']}'),
                                    Text('User ID: ${details['user_id']}'),
                                    Text('Center ID: ${details['center_id']}'),
                                    Text('Status: ${details['status'] ?? '-'}'),
                                    Text(
                                      'Issued By: ${details['issued_by'] ?? '-'}',
                                    ),
                                    Text(
                                      'Issue Date: ${details['issue_date'] ?? '-'}',
                                    ),
                                  ],
                                ),
                                textConfirm: 'Close',
                                onConfirm: () => Get.back(),
                              );
                            }
                          },
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
