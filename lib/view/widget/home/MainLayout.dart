import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink/view/screen/notification/NotificationsPage.dart';
import 'package:medilink/view/screen/profile/ProfilePage.dart';
import 'package:medilink/view/widget/LanguageDialog.dart';
import 'package:medilink/view/widget/home/Sidebar.dart';
import 'package:medilink/controller/ThemeController.dart';
import 'package:medilink/core/localization/changelocal.dart';


class MainLayout extends StatelessWidget {
  MainLayout({Key? key}) : super(key: key);

  final SidebarController sidebarController = Get.find<SidebarController>();
  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    final isDark = themeController.themeMode.value == ThemeMode.dark;
    final iconColor = isDark ? Colors.blue[200] : Colors.blue[800];

    return Scaffold(
      body: Column(
        children: [
          // ✅ الشريط العلوي الثابت
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // ◀️ الشعار والاسم
                Row(
                  children: [
                    Image.asset('assets/images/logo.png', height: 40),
                    const SizedBox(width: 10),
                    Text(
                      'MediLink',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),

                // ▶️ الإعدادات والإشعارات والحساب
                Row(
                  children: [
                    // ⚙️ قائمة الإعدادات المنسدلة
                    PopupMenuButton<String>(
                      icon: Icon(Icons.settings, color: iconColor),
                      tooltip: "Settings",
                      color: Colors.blue.shade50.withOpacity(0.95),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      offset: const Offset(0, 45),
                      elevation: 10,
                      onSelected: (value) {
                        if (value == 'theme') {
                          themeController.toggleTheme();
                        } else if (value == 'language_dialog') {
                          showDialog(
                            context: context,
                            builder: (context) => const LanguageDialog(),
                          );
                        }
                      },
                      itemBuilder: (BuildContext context) => [
                        PopupMenuItem<String>(
                          value: 'theme',
                          child: Row(
                            children: [
                              Icon(
                                isDark ? Icons.light_mode : Icons.dark_mode,
                                color: Colors.blue[800],
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'تبديل الوضع',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.blue[900],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const PopupMenuDivider(),
                        PopupMenuItem<String>(
                          value: 'language_dialog',
                          child: Row(
                            children: [
                              Icon(Icons.language, color: Colors.blue[800]),
                              const SizedBox(width: 10),
                              Text(
                                'اللغة',
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

                    // 🔔 الإشعارات
                    IconButton(
                      icon: Icon(Icons.notifications_none, color: iconColor),
                      tooltip: "Notifications",
                      onPressed: () {
                        sidebarController.selectedIndex.value = 30;
                      },
                    ),

                    const SizedBox(width: 8),

                    // 👤 الحساب
                    IconButton(
                      icon: Icon(Icons.account_circle_outlined, color: iconColor),
                      tooltip: "Profile",
                      onPressed: () {
                        sidebarController.selectedIndex.value = 40;
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ✅ الصف الكامل للـ Sidebar والمحتوى
          Expanded(
            child: Row(
              children: [
                Sidebar(),
                Expanded(
                  child: Obx(() {
                    switch (sidebarController.selectedIndex.value) {
                      case 0:
                        return const Center(child: Text("Dashboard Page"));
                      case 30:
                        return NotificationPage();
                      case 40:
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
