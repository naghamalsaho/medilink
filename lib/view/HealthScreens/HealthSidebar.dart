import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink/controller/ThemeController.dart';

class HealthSidebarController extends GetxController {
  RxInt selectedIndex = 0.obs;
}

class HealthSidebar extends StatelessWidget {
  final HealthSidebarController sidebarController =
      Get.find<HealthSidebarController>();

  final List<Map<String, dynamic>> menuItems = [
    {'icon': Icons.home_outlined, 'label': 'Dashboard'},
    {'icon': Icons.apartment, 'label': 'Medical Centers'},
    {'icon': Icons.people_outline, 'label': 'Center Managers'},
    {'icon': Icons.security, 'label': 'Powers'},
    {'icon': Icons.pie_chart_outline, 'label': 'Reports'},
  ];

  final Color sidebarBg = const Color(0xFFF7F8FA);
  final Color selectedColor = Color(0xFF1E7F5C); // Blue
  final Color hoverColor = Color(0xFFEAF2FF);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        width: 250,
        decoration: BoxDecoration(
          color: sidebarBg,
          border: Border(right: BorderSide(color: Color(0xFF1E7F5C), width: 1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),

            // 🔹 Menu items
            ...List.generate(menuItems.length, (index) {
              final item = menuItems[index];
              final isSelected = sidebarController.selectedIndex.value == index;

              return InkWell(
                onTap: () => sidebarController.selectedIndex.value = index,
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
                        color: isSelected ? selectedColor : Color(0xFF1E7F5C),
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