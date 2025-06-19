import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink/view/screen/SettingsPage.dart';
import 'package:medilink/view/widget/Sidebar.dart';


class MainLayout extends StatelessWidget {
  MainLayout({Key? key}) : super(key: key);
  final SidebarController sidebarController = Get.find<SidebarController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Sidebar(),
          Expanded(
            child: Obx(() {
              switch (sidebarController.selectedIndex.value) {
                case 0:
                 // return DashboardPage();
                case 8:
                  return SettingsPage();
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
    );
  }
}
