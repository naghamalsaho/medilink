import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:medilink/controller/profileController.dart';
import 'package:medilink/core/constants/AppColor.dart';
import 'package:medilink/core/services/MyServices.dart';
import 'package:medilink/view/SecretaryScreens/profile/EditProfilePage.dart';
import 'package:medilink/view/widget/login/PulsingLogo.dart';
import 'package:medilink/view/widget/profile/ProfileAvatar.dart';
class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<ProfileController>();
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Card(
          elevation: 8,
          margin: const EdgeInsets.all(24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Colors.lightBlueAccent, width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          
              SizedBox(
                height: 200,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(right: 24, bottom: -90, child: const ProfileAvatar()),
                  ],
                ),
              ),

            
              Padding(
                padding: const EdgeInsets.all(24),
                child: Obx(() {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      Text(ctrl.name.value,
                          style: theme.textTheme.headlineMedium!
                              .copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(ctrl.role.value,
                          style: theme.textTheme.bodyLarge!
                              .copyWith(color: Colors.green)),
                      const SizedBox(height: 8),
                      Text('Assigned Center: ${ctrl.hospital.value}',
                          style: theme.textTheme.bodySmall!
                              .copyWith(color: Colors.grey[600])),
                      const SizedBox(height: 32),

                      Text('Contact Information',
                          style: theme.textTheme.titleMedium!
                              .copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      ContactCard(
                        icon: Icons.email,
                        text: ctrl.email.value,
                        color: Colors.blueAccent,
                      ),
                      const SizedBox(height: 12),
                      ContactCard(
                        icon: Icons.phone,
                        text: ctrl.phone.value,
                        color: Colors.green,
                      ),
                      const SizedBox(height: 12),
                      ContactCard(
                        icon: Icons.home,
                        text: ctrl.address.value,
                        color: Colors.purple,
                      ),

                      const SizedBox(height: 32),
                      Text('Responsibilities',
                          style: theme.textTheme.titleMedium!
                              .copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(
                        'Your role is vital in keeping our healthcare system running efficiently.',
                        style: theme.textTheme.bodyMedium!
                            .copyWith(color: Colors.grey[700], fontStyle: FontStyle.italic),
                      ),

                      const SizedBox(height: 32),
                      Text('Quick Actions',
                          style: theme.textTheme.titleMedium!
                              .copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      OutlinedButton(
                        onPressed: () => Get.to(() => const EditProfilePage()),
                        style: OutlinedButton.styleFrom(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text("Update Profile"),
                      ),
                    ],
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