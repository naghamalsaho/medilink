import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:medilink/controller/profileController.dart';
import 'package:medilink/core/constants/AppColor.dart';
import 'package:medilink/view/screen/profile/EditProfilePage.dart';
import 'package:medilink/view/widget/login/PulsingLogo.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({Key? key}) : super(key: key);
  final UserController userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        
        child: Card(
          
          elevation: 8,
          margin: const EdgeInsets.all(24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(
              color: Colors.lightBlueAccent,
              width: 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [              
              // Header section
              Container(
                height: 200,
                clipBehavior: Clip.none,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF2196F3), Color(0xFF673AB7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [                    
                   Obx(() => Positioned(
  right: 24,
  bottom: -90,
  child: userController.profileImageBytes.value != null ||
          userController.profileImagePath.value.isNotEmpty
      ? CircleAvatar(
          radius: 120,
          backgroundColor: Colors.white,
          backgroundImage:
              userController.profileImageBytes.value != null
                  ? MemoryImage(userController.profileImageBytes.value!)
                  : FileImage(File(userController.profileImagePath.value))
                      as ImageProvider,
        )
      : Container(
          width: 120 * 2,
          height: 120 * 2,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child:  Center(child: SizedBox(
  width: 200,
  height: 200,
  child: Lottie.asset(
      'assets/lottie/Animationprofile.json',
      fit: BoxFit.contain,
    ),
),),
        ),
))

            ,
                  ],
                ),
              ),

              // Content section
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [                    
                    const SizedBox(height: 40),
                   Obx(() => Text(
  userController.userName.value,
  style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
)),

                    const SizedBox(height: 8),
                   Obx(() =>  Text(
                      userController.userRole.value,
                      style: theme.textTheme.bodyLarge
                          ?.copyWith(color: AppColor.greenw),
                    ) ),
                    const SizedBox(height: 8),
                   Obx(() =>  Text(
                      'Assigned Medical Center: ${userController.userHospital.value}',
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: Colors.grey[600]),
                   )),
                    const SizedBox(height: 32),

                     Text(
                      'Contact Information',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    // Contact cards
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      color: AppColor.accent.withOpacity(0.3),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Icon(Icons.email, color: AppColor.accent),
                            const SizedBox(width: 12),
                            Expanded(
                                child: Obx(() => Text(
    userController.userEmail.value,
    style: TextStyle(
      fontWeight: FontWeight.w500,
      color: Theme.of(context).textTheme.bodyLarge?.color,
    ),
  )),
),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      color: AppColor.greenw.withOpacity(0.3),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Icon(Icons.phone, color: AppColor.greenw),
                            const SizedBox(width: 12),
                            Expanded(
                               child: Obx(() => Text(
    userController.userPhone.value,
    style: TextStyle(
      fontWeight: FontWeight.w500,
      color: Theme.of(context).textTheme.bodyLarge?.color,
    ),
  )),
),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      color: AppColor.purplw.withOpacity(0.1),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Icon(Icons.home, color: AppColor.purplw),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Obx(() => Text(
    userController.userAddress.value,
    style: TextStyle(
      fontWeight: FontWeight.w500,
      color: Theme.of(context).textTheme.bodyLarge?.color,
    ),
  )),
),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    Text(
                      'Responsibilities',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                
Text(
  'Your role is vital in keeping our healthcare system running efficiently — thank you for your dedication and service.',
  style: theme.textTheme.bodyMedium?.copyWith(
    color: Colors.grey[700],
    fontStyle: FontStyle.italic,
    height: 1.5,
  ),
),

                    const SizedBox(height: 32),

                    Text(
                      'Quick Actions',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [                        
                       
                       // const SizedBox(width: 16),
                        OutlinedButton(
                          onPressed: () {
                            Get.to(() => const EditProfilePage());
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            side: const BorderSide(color: Colors.grey),
                          ),
                          child: const Text("Update Profile"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
