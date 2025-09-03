import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink/controller/MedicalFiles/MedicalFilesController%20.dart';
import 'package:url_launcher/url_launcher.dart';

class MedicalFilesDialog extends StatelessWidget {
  final int patientId;

  MedicalFilesDialog({super.key, required this.patientId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MedicalFilesController(patientId));
    controller.fetchFiles();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 600,
        height: 500,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                const Text(
                  "Medical Files",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () => controller.uploadFile(),
                  icon: const Icon(Icons.upload_file),
                  label: const Text("Upload"),
                ),
              ],
            ),
            const Divider(),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value)
                  return const Center(child: CircularProgressIndicator());
                if (controller.files.isEmpty)
                  return const Center(child: Text("No medical files"));
                return ListView.builder(
                  itemCount: controller.files.length,
                  itemBuilder: (context, index) {
                    final file = controller.files[index];
                    return ListTile(
                      title: Text(file['file_url'].split('/').last),
                      subtitle: Text("Uploaded: ${file['upload_date']}"),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => controller.deleteFile(file['id']),
                      ),
                      leading: IconButton(
                        icon: const Icon(Icons.open_in_new, color: Colors.blue),
                        onPressed: () async {
                          final url = file['file_url'];
                          if (await canLaunchUrl(Uri.parse(url))) {
                            await launchUrl(
                              Uri.parse(url),
                              mode: LaunchMode.externalApplication,
                            );
                          }
                        },
                      ),
                    );
                  },
                );
              }),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Close"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
