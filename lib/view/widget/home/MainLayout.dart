import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:medilink/view/screen/notification/NotificationsPage.dart';
import 'package:medilink/view/screen/profile/ProfilePage.dart';

import 'package:medilink/view/widget/home/Sidebar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


import 'package:medilink/view/widget/home/Sidebar.dart';


class MainLayout extends StatelessWidget {
  MainLayout({Key? key}) : super(key: key);
  final SidebarController sidebarController = Get.find<SidebarController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // ✅ الشريط العلوي الثابت
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // ◀️ جهة اليسار: الشعار + الاسم
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

                // ▶️ جهة اليمين: إشعارات + الحساب
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.notifications_none),
                      tooltip: "Notifications",
                      onPressed: () {
                        sidebarController.selectedIndex.value = 30; // إشعارات
                      },
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: Icon(Icons.account_circle_outlined),
                      tooltip: "Profile",
                      onPressed: () {
                        sidebarController.selectedIndex.value = 40; // البروفايل
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ✅ أسفل الشريط: الصف الكامل للـ Sidebar والمحتوى المتغير
          Expanded(
            child: Row(
              children: [
                Sidebar(),

                // ✅ المحتوى حسب الزر المختار
                Expanded(
                  child: Obx(() {
                    switch (sidebarController.selectedIndex.value) {
                      case 0:
                       // return DashboardPage(); // لوحة القيادة
                      case 30:
                        return NotificationPage(); // الإشعارات
                      case 99:
                        return ProfilePage(); // الملف الشخصي
                      case 6:
                       // return SettingsCircleMenu(); // الإعدادات
                      default:
                        return Center(
                          child: Text(
                            'Page ${sidebarController.selectedIndex.value}',
                            style: TextStyle(fontSize: 24),
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
