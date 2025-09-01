// 📌 HealthSidebar.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HealthSidebarController extends GetxController {
  RxInt selectedIndex = 0.obs;
}

class HealthSidebar extends StatelessWidget {
  final HealthSidebarController sidebarController =
      Get.find<HealthSidebarController>();

  // ✅ القائمة الأساسية لوزارة الصحة (سوبر أدمن)
  final List<Map<String, dynamic>> menuItems = [
    {'icon': Icons.dashboard_outlined, 'label': 'Dashboard'}, // إحصائيات عامة
    {
      'icon': Icons.medical_services_outlined,
      'label': 'Doctors',
    }, // إدارة الأطباء
    {
      'icon': Icons.apartment_outlined,
      'label': 'Medical Centers',
    }, // إدارة المراكز
    {
      'icon': Icons.manage_accounts_outlined,
      'label': 'Center Managers',
    }, // إدارة مدراء المراكز
    {'icon': Icons.people_outline, 'label': 'Users'}, // إدارة المستخدمين
    {'icon': Icons.assignment_outlined, 'label': 'Licenses'}, // إدارة التراخيص
    {'icon': Icons.pie_chart_outline, 'label': 'Reports'}, // التقارير
    // {
    //   'icon': Icons.person_add_alt_1,
    //   'label': 'Register Center Admin',
    // }, // تسجيل مدير مركز جديد
  ];

  final Color sidebarBg = const Color(0xFFFDFEFE); // خلفية فاتحة
  final Color selectedColor = const Color(0xFF00ACC1); // اللون الجديد
  final Color hoverColor = const Color(0xFFB2EBF2); // أخضر/تركواز فاتح باهت

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        width: 250,
        decoration: BoxDecoration(
          color: sidebarBg,
          border: const Border(
            right: BorderSide(color: Color(0xFFE0E0E0), width: 1),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),

            // 🔹 قائمة العناصر
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
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
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
