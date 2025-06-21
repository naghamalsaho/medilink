import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink/controller/ThemeController.dart';
import 'package:medilink/core/constants/AppColor.dart';
import 'package:medilink/view/widget/RadialSettingsButton.dart';

class SidebarController extends GetxController {
  RxInt selectedIndex = 0.obs;
  RxBool showSettingsMenu = false.obs;
  RxDouble settingsRotation = 0.0.obs;
}

class Sidebar extends StatelessWidget {
  final ThemeController themeController = Get.find<ThemeController>();
  final SidebarController sidebarController = Get.put(SidebarController());

  final List<Map<String, dynamic>> staticItems = [
    {'icon': Icons.dashboard, 'label': "Dashboard"},
    {'icon': Icons.calendar_today, 'label': "Appointments"},
    {'icon': Icons.manage_accounts, 'label': "Patients"},
    {'icon': Icons.schedule, 'label': "Doctors"},
    {'icon': Icons.list_alt, 'label': "Records"},
    {'icon': Icons.insert_chart_outlined, 'label': "Reports"},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 270,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Expanded(
            child: ListView.builder(
              itemCount: staticItems.length + 1,
              itemBuilder: (context, index) {
                if (index == staticItems.length) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 0, top: 8, bottom: 12),
                 //   child: RadialSettingsButton(
                 //     themeController: themeController,
                 //     sidebarController: sidebarController,
                 //   ),
                  );
                }

                final item = staticItems[index];
                final isSelected =
                    sidebarController.selectedIndex.value == index;

                return Padding(
  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
  child: Obx(() {
    final isSelected = sidebarController.selectedIndex.value == index;

    return GestureDetector(
      onTap: () {
        sidebarController.selectedIndex.value = index;
        sidebarController.showSettingsMenu.value = false;
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: isSelected ? AppColor.primary.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColor.primary : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColor.primary.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Icon(
              item['icon'],
              color: isSelected ? AppColor.accent : Theme.of(context).iconTheme.color,
            ),
            const SizedBox(width: 12),
            Text(
              item['label'],
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: isSelected
                        ? AppColor.accent
                        : Theme.of(context).textTheme.bodyLarge!.color,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
            ),
          ],
        ),
      ),
    );
  }),
);


              },
            ),
          ),
        ],
      ),
    );
  }
}
