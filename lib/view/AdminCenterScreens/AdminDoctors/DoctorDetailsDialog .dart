import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DoctorDetailsDialog extends StatelessWidget {
  final Map<String, dynamic> doctor;

  const DoctorDetailsDialog({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    final profile = doctor["profile"] ?? {};
    final String? certPath = profile["certificate"];
    final String? certUrl =
        certPath != null
            ? "https://medical.doctorme.site/storage/$certPath"
            : null;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        width: 650, // 🟢 أكبر
        height: 500, // 🟢 أكبر مع مساحة للسكرول
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              doctor["full_name"] ?? "---",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Divider(),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("📧 Email: ${doctor["email"] ?? "---"}"),
                    Text("📞 Phone: ${doctor["phone"] ?? "---"}"),
                    Text("🏥 Centers Count: ${doctor["centers_count"] ?? 0}"),
                    Text(
                      "📌 Invitation Status: ${doctor["invitation_status"] ?? "unknown"}",
                    ),
                    const SizedBox(height: 12),

                    Text(
                      "🩺 Specialty ID: ${profile["specialty_id"] ?? "---"}",
                    ),
                    Text(
                      "⏳ Experience: ${profile["years_of_experience"] ?? "N/A"} years",
                    ),
                    const SizedBox(height: 12),

                    // ✅ عرض الشهادة
                    if (certUrl != null) ...[
                      const Text("📄 Certificate:"),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () async {
                          if (await canLaunchUrl(Uri.parse(certUrl))) {
                            await launchUrl(
                              Uri.parse(certUrl),
                              mode: LaunchMode.externalApplication,
                            );
                          }
                        },
                        child: Image.network(
                          certUrl,
                          height: 150,
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, err, _) => Text("🔗 $certUrl"),
                        ),
                      ),
                    ] else
                      const Text("📄 Certificate: N/A"),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
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
