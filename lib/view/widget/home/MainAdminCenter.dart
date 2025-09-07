import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:medilink/controller/auth/logoutController.dart';
import 'package:medilink/controller/profileController.dart';
import 'package:medilink/controller/ThemeController.dart';
import 'package:medilink/view/AdminCenterScreens/AdminDashbord/AdminSidbar.dart';
import 'package:medilink/view/AdminCenterScreens/AdminDoctors/AdminDoctorsPage.dart';
import 'package:medilink/view/AdminCenterScreens/AdminSecretariesPage.dart';
import 'package:medilink/view/AdminCenterScreens/Services.dart/ServicesPage%20.dart';
import 'package:medilink/view/AdminCenterScreens/SideBarElements/AdminDashbord.dart';
import 'package:medilink/view/AdminCenterScreens/SideBarElements/reborts/ReportsPage%20.dart';
import 'package:medilink/view/SecretaryScreens/AppointmentPage.dart';
import 'package:medilink/view/SecretaryScreens/notification/NotificationsPage.dart';
import 'package:medilink/view/SecretaryScreens/profile/ProfilePage.dart';
import 'package:medilink/view/widget/LanguageDialog.dart';
import 'package:medilink/view/widget/login/PulsingLogo.dart';

class MainAdminCenter extends StatelessWidget {
  MainAdminCenter({Key? key}) : super(key: key);

  final AdminSidebarController sidebarController = Get.put(
    AdminSidebarController(),
  );
  final ThemeController themeController = Get.find<ThemeController>();
  final ProfileController userController = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    final isDark = themeController.themeMode.value == ThemeMode.dark;
    final iconColor = isDark ? const Color(0xFF1E7F5C) : Colors.grey[700];
    final AuthController authCtrl = Get.put(AuthController());

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      body: Column(
        children: [
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    PulsingHeart(),
                    const SizedBox(width: 12),
                    const Text(
                      'MediLink',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    PopupMenuButton<String>(
                      icon: Icon(Icons.settings, color: iconColor),
                      tooltip: 'Settings',
                      color: const Color(0xFF1E7F5C).withOpacity(0.95),
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
                                    color: const Color(0xFF1E7F5C),
                                  ),
                                  const SizedBox(width: 10),
                                  const Text(
                                    ' change mode',
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
                                children: const [
                                  Icon(
                                    Icons.language,
                                    color: Color(0xFF1E7F5C),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'language',
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
                                  userController.name.value,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  userController.role.value,
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

          // ✅ السايد بار + الصفحات
          Expanded(
            child: Row(
              children: [
                AdminSidebar(), // Sidebar الجديد
                Expanded(
                  child: Obx(() {
                    switch (sidebarController.selectedIndex.value) {
                      case 0:
                        return AdminDashbord();
                      case 1:
                        return AdminSecretariesPage();
                      case 2:
                        return AdminDoctorsPage(); // الآن يفتح صح
                      case 3:
                        return ReportsPage();
                      case 4:
                        return ServicesPage();

                      case 30:
                        return NotificationPage();
                      case 99:
                        return ProfilePage();
                      default:
                        return Center(
                          child: Text(
                            'Page ${sidebarController.selectedIndex.value}',
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
