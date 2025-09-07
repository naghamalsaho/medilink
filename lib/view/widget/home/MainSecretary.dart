import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:medilink/controller/auth/logoutController.dart';
import 'package:medilink/controller/profileController.dart';
import 'package:medilink/controller/ThemeController.dart';
import 'package:medilink/view/SecretaryScreens/AppointmentPage.dart';
import 'package:medilink/view/SecretaryScreens/ReportsPageSecretary%20.dart';
import 'package:medilink/view/SecretaryScreens/SideBarElements/DashboardPage.dart';
import 'package:medilink/view/SecretaryScreens/SideBarElements/DoctorsPage.dart';
import 'package:medilink/view/SecretaryScreens/SideBarElements/PatientsPage.dart';
import 'package:medilink/view/SecretaryScreens/notification/NotificationsPage.dart';
import 'package:medilink/view/SecretaryScreens/profile/EditProfilePage.dart';
import 'package:medilink/view/SecretaryScreens/profile/ProfilePage.dart';
import 'package:medilink/view/widget/LanguageDialog.dart';
import 'package:medilink/view/widget/home/SecretarySidebar.dart';
import 'package:medilink/view/widget/login/PulsingLogo.dart';

class MainSecretary extends StatelessWidget {
  MainSecretary({Key? key}) : super(key: key);

  final SidebarController sidebarController = Get.find<SidebarController>();
  final ThemeController themeController = Get.find<ThemeController>();
  final ProfileController userController = Get.find<ProfileController>();
  final AuthController authCtrl = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    final isDark = themeController.themeMode.value == ThemeMode.dark;
    final iconColor = isDark ? Colors.blue[200] : Colors.grey[700];

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
                      color: Colors.blue.shade50.withOpacity(0.95),

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
                                    color: Colors.blue[800],
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    ' change mode',

                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.blue[900],
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
                                  Icon(Icons.language, color: Colors.blue[800]),
                                  const SizedBox(width: 10),
                                  Text(
                                    'language',

                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.blue[900],
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

                    IconButton(
                      icon: Icon(Icons.logout, color: iconColor),
                      tooltip: 'Logout',
                      onPressed: () async {
                        // تأكيد خروج
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder:
                              (_) => AlertDialog(
                                title: const Text('Confirm logout'),
                                content: const Text(
                                  'Are you sure you want to log out?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed:
                                        () => Navigator.pop(context, false),
                                    child: const Text('cancel'),
                                  ),
                                  ElevatedButton(
                                    onPressed:
                                        () => Navigator.pop(context, true),
                                    child: const Text('Exit'),
                                  ),
                                ],
                              ),
                        );

                        if (confirm == true) {
                          // اظهار مؤشر تحميل modal
                          Get.dialog(
                            const Center(child: CircularProgressIndicator()),
                            barrierDismissible: false,
                          );
                          await authCtrl.logout();
                          // اغلاق مؤشر التحميل لو مفتوح
                          try {
                            if (Get.isDialogOpen ?? false) Get.back();
                          } catch (_) {}
                        }
                      },
                    ),
                    const SizedBox(width: 10),

                    GestureDetector(
                      onTap: () => sidebarController.selectedIndex.value = 99,
                      child: Obx(() {
                        return Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  userController
                                      .name
                                      .value, // استخدم name بدلاً من userName
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  userController
                                      .role
                                      .value, // استخدم role بدلاً من userRole
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
                                    userController.profileImageBytes.value !=
                                            null
                                        ? Image.memory(
                                          userController
                                              .profileImageBytes
                                              .value!,
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
                SecretarySidebar(),
                Expanded(
                  child: Obx(() {
                    switch (sidebarController.selectedIndex.value) {
                      case 0:
                        return const DashboardPage();
                      case 1:
                        return AppointmentsPage();

                      case 2:
                        return PatientsPage();
                      case 3:
                        return DoctorsPage();

                      case 4:
                        return ReportsPageSecretary();
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
