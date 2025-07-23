import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:lottie/lottie.dart';

import 'package:medilink/controller/profileController.dart';
import 'package:medilink/controller/ThemeController.dart';
import 'package:medilink/view/HealthScreens/HealthDashboardPage.dart';
import 'package:medilink/view/HealthScreens/HealthSidebar.dart';
import 'package:medilink/view/HealthScreens/MedicalCenters.dart';
import 'package:medilink/view/SecretaryScreens/AppointmentPage.dart';
import 'package:medilink/view/SecretaryScreens/DashboardPage.dart';
import 'package:medilink/view/SecretaryScreens/Reports/ReportsPage.dart';
import 'package:medilink/view/SecretaryScreens/SideBarElements/DoctorsPage.dart';
import 'package:medilink/view/SecretaryScreens/SideBarElements/PatientsPage.dart';
import 'package:medilink/view/SecretaryScreens/notification/NotificationsPage.dart';
import 'package:medilink/view/SecretaryScreens/profile/ProfilePage.dart';
import 'package:medilink/view/widget/LanguageDialog.dart';
import 'package:medilink/view/widget/home/SecretarySidebar.dart';
import 'package:medilink/view/widget/login/PulsingLogo.dart';

class MainHealth extends StatelessWidget {
  MainHealth({Key? key}) : super(key: key);

  final SidebarController sidebarController = Get.find<SidebarController>();
  final ThemeController themeController = Get.find<ThemeController>();
  final UserController userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    final isDark = themeController.themeMode.value == ThemeMode.dark;
    final iconColor = isDark ? Color(0xFF1E7F5C) : Colors.grey[700];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      body: Column(
        children: [
          // الشريط العلوي الثابت
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // شعار واسم التطبيق
                Row(
                  children: [
                    PulsingHeart(),
                    const SizedBox(width: 12),
                    Text(
                      'MediLink',
                      style: TextStyle(
                        fontFamily: 'Cairo', // تأكد أن الخط معرف
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),

                // الإعدادات والإشعارات والحساب
                Row(
                  children: [
                    // قائمة الإعدادات المنسدلة
                    PopupMenuButton<String>(
                      icon: Icon(Icons.settings, color: iconColor),
                      tooltip: 'Settings',
                      color: Color(0xFF1E7F5C).withOpacity(0.95),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      onSelected: (value) {
                        if (value == 'theme') {
                          themeController.toggleTheme();
                        } else if (value == 'language_dialog') {
                          showDialog(
                            context: context,
                            builder: (_) => const LanguageDialog(),
                          );
                        }
                      },
                      itemBuilder:
                          (_) => [
                            PopupMenuItem(
                              value: 'theme',
                              child: Row(
                                children: [
                                  Icon(
                                    isDark ? Icons.light_mode : Icons.dark_mode,
                                    color: Color(0xFF1E7F5C),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    'تبديل الوضع',

                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF1E7F5C),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const PopupMenuDivider(),

                            PopupMenuItem(
                              value: 'language_dialog',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.language,
                                    color: Color(0xFF1E7F5C),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    'اللغة',

                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF1E7F5C),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                    ),
                    const SizedBox(width: 10),

                    IconButton(
                      icon: Icon(Icons.notifications_none, color: iconColor),
                      tooltip: 'Notifications',
                      onPressed:
                          () => sidebarController.selectedIndex.value = 30,
                    ),
                    const SizedBox(width: 8),

                    // عرض صورة واسم المستخدم
                    // عرض صورة واسم المستخدم
                    GestureDetector(
                      onTap: () => sidebarController.selectedIndex.value = 99,
                      child: Obx(() {
                        final hasImage =
                            userController.profileImageBytes.value != null ||
                            (!kIsWeb &&
                                userController
                                    .profileImagePath
                                    .value
                                    .isNotEmpty);

                        return Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  userController.userName.value,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  userController.userRole.value,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 8),
                            ClipOval(
                              child: SizedBox(
                                width: 36,
                                height: 36,
                                child:
                                    hasImage
                                        ? Image(
                                          image:
                                              userController
                                                          .profileImageBytes
                                                          .value !=
                                                      null
                                                  ? MemoryImage(
                                                    userController
                                                        .profileImageBytes
                                                        .value!,
                                                  )
                                                  : FileImage(
                                                        File(
                                                          userController
                                                              .profileImagePath
                                                              .value,
                                                        ),
                                                      )
                                                      as ImageProvider,
                                          fit: BoxFit.cover,
                                        )
                                        : Lottie.asset(
                                          'assets/lottie/Animationprofile.json',
                                          fit: BoxFit.contain,
                                        ),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // المحتوى مع الشريط الجانبي
          Expanded(
            child: Row(
              children: [
                HealthSidebar(),
                Expanded(
                  child: Obx(() {
                    switch (sidebarController.selectedIndex.value) {
                      case 0:
                        return const HealthDashboardPage();
                      case 1:
                        return MedicalCenters();

                      // case 2:
                      //   return CenterManagers();
                      // case 3:
                      //   return Powers();

                      case 4:
                        return ReportsPage();
                      case 30:
                        return NotificationPage();
                      case 99:
                        return ProfilePage();
                      default:
                        return Center(
                          child: Text(
                            'Page \${sidebarController.selectedIndex.value}',
                            style: const TextStyle(fontSize: 24),
                          ),
                        );
                    }
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
