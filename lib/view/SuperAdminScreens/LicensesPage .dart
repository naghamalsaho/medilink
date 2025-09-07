import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink/controller/SuperAdminController/LicensesController%20.dart';

class LicensesPage extends StatelessWidget {
  final LicensesController controller = Get.put(LicensesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9FAFB),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Licenses Management',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }
                if (controller.licensesList.isEmpty) {
                  return Center(child: Text('لا توجد تراخيص حالياً'));
                }
                return ListView.builder(
                  itemCount: controller.licensesList.length,
                  itemBuilder: (context, index) {
                    var license = controller.licensesList[index];
                    var user = license['user'];
                    var center = license['center'];
                    String status = license['status'] ?? 'pending';

                    // زر البداية: رمادي إذا approved و المركز موجود
                    bool isInitialGray = status == 'approved' && center != null;

                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user['name'] ?? '-',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text('Email: ${user['email'] ?? '-'}'),
                            Text('Center: ${center['name'] ?? '-'}'),
                            Text('Issued By: ${license['issued_by'] ?? '-'}'),
                            Text('Issue Date: ${license['issue_date'] ?? '-'}'),
                            Text('Status: $status'),
                            SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  onPressed:
                                      isInitialGray || status == 'approved'
                                          ? () =>
                                              controller.updateLicenseStatus(
                                                license['id'],
                                                'approved',
                                              )
                                          : () =>
                                              controller.updateLicenseStatus(
                                                license['id'],
                                                'approved',
                                              ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        isInitialGray
                                            ? Colors.grey
                                            : Colors.green,
                                  ),
                                  child: Text('Approve'),
                                ),
                                SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed:
                                      isInitialGray || status == 'rejected'
                                          ? () =>
                                              controller.updateLicenseStatus(
                                                license['id'],
                                                'rejected',
                                              )
                                          : () =>
                                              controller.updateLicenseStatus(
                                                license['id'],
                                                'rejected',
                                              ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        isInitialGray
                                            ? Colors.grey
                                            : Colors.red,
                                  ),
                                  child: Text('Reject'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
