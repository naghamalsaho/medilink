import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink/view/screen/DashboardPage.dart';
import 'package:medilink/view/screen/notification/NotificationsPage.dart';
import 'package:medilink/view/screen/profile/ProfilePage.dart';
import 'package:medilink/view/widget/LanguageDialog.dart';
import 'package:medilink/view/widget/home/Sidebar.dart';
import 'package:medilink/controller/ThemeController.dart';
import 'package:medilink/view/widget/login/PulsingLogo.dart';

class MainLayout extends StatelessWidget {
  MainLayout({Key? key}) : super(key: key);

  final SidebarController sidebarController = Get.find<SidebarController>();
  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    final isDark = themeController.themeMode.value == ThemeMode.dark;
    final iconColor = isDark ? Colors.blue[200] : Colors.grey[700];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      body: Column(
        children: [
          // ✅ Custom AppBar
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Logo + App Name
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

                // Actions: settings, notifications, profile
                Row(
                  children: [
                    PopupMenuButton<String>(
                      icon: Icon(Icons.settings, color: iconColor),
                      tooltip: "Settings",
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
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
                      itemBuilder:
                          (BuildContext context) => [
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
                                    'Toggle Theme',
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
                                    'Language',
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
                      tooltip: "Notifications",
                      onPressed: () {
                        sidebarController.selectedIndex.value = 30;
                      },
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: Icon(
                        Icons.account_circle_outlined,
                        color: iconColor,
                      ),
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

          // ✅ Body: Sidebar + Content
          Expanded(
            child: Row(
              children: [
                Sidebar(),
                Expanded(
                  child: Obx(() {
                    switch (sidebarController.selectedIndex.value) {
                      case 0:
                        return DashboardPage();
                      case 1:
                        return const Center(child: Text("Appointments Page"));
                      case 2:
                        return const Center(child: Text("Patients Page"));
                      case 3:
                        return const Center(child: Text("Doctors Page"));
                      case 4:
                        return const Center(child: Text("Records Page"));
                      case 5:
                        return const Center(child: Text("Reports Page"));
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
