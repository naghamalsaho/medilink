import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink/controller/ThemeController.dart';
import 'package:medilink/core/constants/AppColor.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({Key? key}) : super(key: key);

  final ThemeController themeController = Get.find<ThemeController>();
  final RxInt selectedIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() {
          final isDark = themeController.themeMode.value == ThemeMode.dark;

          final List<_BarItem> barItems = [
            _BarItem(
              icon: isDark ? Icons.light_mode : Icons.dark_mode,
              label: isDark ? 'Light Mode' : 'Dark Mode',
            ),
            const _BarItem(icon: Icons.language, label: 'Lang'),
            const _BarItem(icon: Icons.info_outline, label: 'Info'),
            const _BarItem(icon: Icons.notifications_none, label: 'Notif'),
            const _BarItem(icon: Icons.account_circle_outlined, label: 'Account'),
          ];

          return Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColor.black.withOpacity(0.1)
                  : AppColor.bgLight.withOpacity(0.4),
              boxShadow: [
                BoxShadow(
                  color: AppColor.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: List.generate(barItems.length, (index) {
                final item = barItems[index];
                final isSelected = selectedIndex.value == index;
                return GestureDetector(
                  onTap: () {
                    selectedIndex.value = index;
                    if (index == 0) {
                      themeController.toggleTheme();
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.only(right: 24),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColor.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          item.icon,
                          size: 20,
                          color: isSelected
                              ? AppColor.accent
                              : (isDark ? AppColor.bgLight : AppColor.black),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          item.label,
                          style: TextStyle(
                            fontSize: 16,
                            color: isSelected
                                ? AppColor.accent
                                : (isDark ? AppColor.bgLight : AppColor.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          );
        }),
        const Expanded(child: SizedBox()),
      ],
    );
  }
}

class _BarItem {
  final IconData icon;
  final String label;
  const _BarItem({required this.icon, required this.label});
}
