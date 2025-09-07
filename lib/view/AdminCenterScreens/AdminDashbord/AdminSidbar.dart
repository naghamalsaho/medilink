// admin_sidebar.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminSidebarController extends GetxController {
  RxInt selectedIndex = 0.obs;
}

class AdminSidebar extends StatelessWidget {
  const AdminSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final AdminSidebarController sidebarController =
        Get.find<AdminSidebarController>();

    final List<Map<String, dynamic>> menuItems = [
      {'icon': Icons.home_outlined, 'label': 'Dashboard'},
      {'icon': Icons.people_outline, 'label': 'Secretaries'},
      {'icon': Icons.local_hospital_outlined, 'label': 'Doctors'},
      {'icon': Icons.pie_chart_outline, 'label': 'Reports'},
      {'icon': Icons.miscellaneous_services_outlined, 'label': 'Services'},
    ];

    final Color sidebarBg = const Color(0xFFF7F8FA);
    final Color selectedColor = Colors.blue;
    final Color hoverColor = const Color(0xFFEAF2FF);

    return Obx(
      () => Container(
        width: 250,
        decoration: BoxDecoration(
          color: sidebarBg,
          border: const Border(right: BorderSide(color: Colors.blue, width: 1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            ...List.generate(menuItems.length, (index) {
              final item = menuItems[index];
              final isSelected = sidebarController.selectedIndex.value == index;

              return InkWell(
                onTap: () {
                  sidebarController.selectedIndex.value = index;
                  print('Selected index: $index');
                },
                borderRadius: BorderRadius.circular(10),
                hoverColor: hoverColor,
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? hoverColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        item['icon'],
                        color: isSelected ? selectedColor : Colors.blue,
                        size: 22,
                      ),
                      const SizedBox(width: 16),
                      Text(
                        item['label'],
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: isSelected ? selectedColor : Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
