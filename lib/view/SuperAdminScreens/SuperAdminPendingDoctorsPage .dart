import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink/controller/SuperAdminController/SuperAdminPendingDoctorsController%20.dart';
import 'package:url_launcher/url_launcher.dart';

class SuperAdminPendingDoctorsPage extends StatelessWidget {
  SuperAdminPendingDoctorsPage({super.key});
  final SuperAdminPendingDoctorsController controller = Get.put(
    SuperAdminPendingDoctorsController(),
  );

  void _confirmAction({
    required String title,
    required String message,
    required VoidCallback onConfirm,
  }) {
    Get.defaultDialog(
      title: title,
      titleStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      middleText: message,
      middleTextStyle: const TextStyle(fontSize: 16),
      textCancel: "Cancel",
      textConfirm: "Confirm",
      confirmTextColor: Colors.white,
      cancelTextColor: Colors.red,
      buttonColor: Color(0xFF00ACC1),
      radius: 16,
      contentPadding: const EdgeInsets.all(20),
      onConfirm: onConfirm,
    );
  }

  // ديالوغ التفاصيل متناسق مع باقي الموقع
  void _showDoctorDetails(Map<String, dynamic> doctor) async {
    final profile = doctor['doctor_profile'] ?? {};
    final user = doctor['user'] ?? {};

    Get.defaultDialog(
      title: "Doctor Profile",
      titleStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Full Name: ${user['full_name'] ?? "-"}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            Text(
              "Specialty ID: ${profile['specialty_id'] ?? "-"}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),

            Text(
              "Status: ${profile['status'] ?? "-"}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                const Text(
                  "Certificate: ",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final url =
                          "https://medical.doctorme.site/${profile['certificate'] ?? ""}";
                      Uri uri = Uri.parse(url);
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri);
                      } else {
                        Get.snackbar(
                          "Error",
                          "Cannot open the certificate link",
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      }
                    },
                    child: Text(
                      profile['certificate'] ?? "-",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      contentPadding: const EdgeInsets.all(20),
      radius: 16,
      textConfirm: "Close",
      confirmTextColor: Colors.white,
      buttonColor: const Color(0xFF00ACC1),
      onConfirm: () => Get.back(),
    );
  }

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
                "Pending Doctors",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 16),
              controller.pendingDoctors.isEmpty
                  ? Center(
                    child: Text(
                      "No pending doctors found.",
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  )
                  : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.pendingDoctors.length,
                    itemBuilder: (context, index) {
                      final doctor = controller.pendingDoctors[index];
                      final doctorId = doctor['doctor_profile']?['id'] ?? 0;

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          leading: const CircleAvatar(
                            backgroundColor: Color(0xFF00ACC1),
                            child: Icon(
                              Icons.medical_services,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          title: Text(
                            doctor['user']?['full_name'] ?? "No name",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            "Status: ${doctor['doctor_profile']?['status'] ?? "No status"}",
                            style: const TextStyle(fontSize: 14),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.visibility,
                                  color: Colors.blue,
                                  size: 24,
                                ),
                                tooltip: "View Details",
                                onPressed: () {
                                  _showDoctorDetails(doctor);
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 24,
                                ),
                                tooltip: "Approve",
                                onPressed: () {
                                  _confirmAction(
                                    title: "Approve Doctor",
                                    message:
                                        "Are you sure you want to approve this doctor?",
                                    onConfirm: () {
                                      controller.approveDoctor(doctorId);
                                      Get.back();
                                    },
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.cancel,
                                  color: Colors.red,
                                  size: 24,
                                ),
                                tooltip: "Reject",
                                onPressed: () {
                                  _confirmAction(
                                    title: "Reject Doctor",
                                    message:
                                        "Are you sure you want to reject this doctor?",
                                    onConfirm: () {
                                      controller.rejectDoctor(doctorId);
                                      Get.back();
                                    },
                                  );
                                },
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
}
