
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:medilink/api_link.dart';

import 'package:medilink/controller/profileController.dart';
import 'package:medilink/view/widget/profile/SectionTitle.dart';
import 'package:medilink/view/widget/profile/card.dart';

typedef ImagePickerCallback = Future<void> Function();

class PhotoSection extends StatelessWidget {
  final Uint8List? tempImageBytes;
  final ImagePickerCallback onPickImage;

  const PhotoSection({
    Key? key,
    required this.tempImageBytes,
    required this.onPickImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProfileController userController = Get.find();

    return ReusableCard(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(16),
      borderRadius: 16,
      child: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: tempImageBytes != null
                      ? Image.memory(
                          tempImageBytes!,
                          fit: BoxFit.cover,
                        )
                      : Obx(() {
                          final photo = userController.profile.value?.profilePhoto;
                          if (photo != null && photo.isNotEmpty) {
                            final url = '${AppLink.server}/$photo';
                            return Image.network(
                              url,
                              fit: BoxFit.cover,
                              errorBuilder: (ctx, err, st) => const Icon(Icons.error),
                            );
                          }
                          return Lottie.asset(
                            'assets/lottie/Animationprofile.json',
                            fit: BoxFit.cover,
                          );
                        }),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: GestureDetector(
                  onTap: onPickImage,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
                    ),
                    child: const Icon(Icons.camera_alt, size: 20, color: Colors.blue),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const SectionTitle('Personal photo'),
          const SizedBox(height: 4),
          const SectionSubtitle(
           '   Click the icon to change your profile picture. It best to use a clear, professional photo. ',
          ),
        ],
      ),
    );
  }
}
