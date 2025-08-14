// lib/view/SecretaryScreens/profile/widgets/ProfileAvatar.dart
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:medilink/api_link.dart';

import 'package:medilink/core/services/MyServices.dart';
import 'package:medilink/controller/profileController.dart';

class ProfileAvatar extends StatelessWidget {
  final Uint8List? tempImageBytes;

  const ProfileAvatar({Key? key, this.tempImageBytes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<ProfileController>();
    final token = Get.find<MyServices>().box.read('token') ?? '';

    return Obx(() {
     
      if (tempImageBytes != null) {
        return CircleAvatar(radius: 90, backgroundImage: MemoryImage(tempImageBytes!));
      }

      final photo = ctrl.profile.value?.profilePhoto;
      if (photo != null && photo.isNotEmpty) {
        final url = '${AppLink.server}/$photo';
        return FutureBuilder<Uint8List?>(
          future: _fetchWithToken(url, token),
          builder: (ctx, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const CircleAvatar(radius: 90, child: CircularProgressIndicator());
            }
            if (snap.hasData && snap.data != null) {
              return CircleAvatar(radius: 90, backgroundImage: MemoryImage(snap.data!));
            }
            return const CircleAvatar(radius: 90, child: Icon(Icons.error, size: 40));
          },
        );
      }

      return const CircleAvatar(radius: 90, child: Icon(Icons.person, size: 60));
    });
  }

  Future<Uint8List?> _fetchWithToken(String url, String token) async {
    try {
      final proxy = "https://api.allorigins.win/raw?url=${Uri.encodeComponent(url)}";
      final res = await http.get(
        Uri.parse(proxy),
        headers: {"Authorization": "Bearer $token"},
      );
      return res.statusCode == 200 ? res.bodyBytes : null;
    } catch (_) {
      return null;
    }
  }
}
class ContactCard extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const ContactCard({
    Key? key,
    required this.icon,
    required this.text,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: color.withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 12),
            Expanded(child: Text(text, style: TextStyle(fontWeight: FontWeight.w500))),
          ],
        ),
      ),
    );
  }
}