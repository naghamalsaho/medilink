import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink/controller/ThemeController.dart';

class SidebarController extends GetxController {
  RxInt selectedIndex = 0.obs;
}

class Sidebar extends StatelessWidget {
  final SidebarController sidebarController = Get.put(SidebarController());

  final List<Map<String, dynamic>> menuItems = [
    {'icon': Icons.home_outlined, 'label': 'Dashboard'},
    {'icon': Icons.event_note_outlined, 'label': 'Appointments'},
    {'icon': Icons.people_outline, 'label': 'Patients'},
    {'icon': Icons.local_hospital_outlined, 'label': 'Doctors'},
    {'icon': Icons.pie_chart_outline, 'label': 'Reports'},
  ];

  final Color sidebarBg = const Color(0xFFF7F8FA);
  final Color selectedColor = Color(0xFF007BFF); // Blue
  final Color hoverColor = Color(0xFFEAF2FF);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        width: 250,
        decoration: BoxDecoration(
          color: sidebarBg,
          border: Border(
            right: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
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
                        color: isSelected ? selectedColor : Colors.grey[600],
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
