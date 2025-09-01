// 📌 MainHealth.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:medilink/controller/profileController.dart';
import 'package:medilink/controller/ThemeController.dart';
import 'package:medilink/view/SuperAdminScreens/CenterAdmins/CenterAdminsPage%20.dart';
import 'package:medilink/view/SuperAdminScreens/HealthSidebar.dart';
import 'package:medilink/view/SuperAdminScreens/Dashbord/SuperAdminDashboardPage%20.dart';
import 'package:medilink/view/SuperAdminScreens/SuperAdminCenters/SuperAdminCentersPage%20.dart';
import 'package:medilink/view/SuperAdminScreens/SuperAdminPendingDoctorsPage%20.dart';
import 'package:medilink/view/widget/LanguageDialog.dart';
import 'package:medilink/view/widget/login/PulsingLogo.dart';

class MainHealth extends StatelessWidget {
  MainHealth({Key? key}) : super(key: key);

  final HealthSidebarController sidebarController = Get.put(
    HealthSidebarController(),
  );
  final ThemeController themeController = Get.find<ThemeController>();
  final ProfileController userController = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    final isDark = themeController.themeMode.value == ThemeMode.dark;
    final iconColor =
        isDark ? const Color.fromARGB(255, 95, 210, 225) : Colors.grey[700];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      body: Column(
        children: [
          // 🔹 الشريط العلوي
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.15),
                  offset: const Offset(0, 2),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // شعار
                Row(
                  children: [
                    PulsingHeart(),
                    const SizedBox(width: 12),
                    Text(
                      'MediLink',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),

                // إعدادات + نوتيفيكشن + حساب
                Row(
                  children: [
                    PopupMenuButton<String>(
                      icon: Icon(Icons.settings, color: iconColor),
                      tooltip: 'Settings',
                      color: const Color.fromARGB(
                        255,
                        127,
                        222,
                        234,
                      ).withOpacity(0.95),
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
                                    color: const Color(0xFF00ACC1),
                                  ),
                                  const SizedBox(width: 10),
                                  const Text(
                                    ' Change Mode',
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
                                    color: Color(0xFF00ACC1),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'Language',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF00ACC1),
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
                      onPressed: () {},
                    ),
                    const SizedBox(width: 8),

                    GestureDetector(
                      onTap: () => sidebarController.selectedIndex.value = 999,
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

          // 🔹 المحتوى مع السايد بار
          Expanded(
            child: Row(
              children: [
                HealthSidebar(),
                Expanded(
                  child: Obx(() {
                    switch (sidebarController.selectedIndex.value) {
                      case 0:
                        return SuperAdminDashboardPage();
                      case 1:
                        return SuperAdminPendingDoctorsPage();
                      case 2:
                        return SuperAdminCentersPage();
                      case 3:
                        return CenterAdminsPage();
                      case 4:
                        return Center(child: Text("👥 Users Management"));
                      case 5:
                        return Center(child: Text("📜 Licenses"));
                      case 6:
                        return Center(child: Text("📑 Reports"));
                      // case 7:
                      //   return Center(child: Text("➕ Register Center Admin"));
                      case 999:
                        return Center(child: Text("🙍 Profile Page"));
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
