
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink/controller/ThemeController.dart';
import 'package:medilink/core/constants/AppColor.dart';
import 'package:medilink/view/widget/home/Sidebar.dart';

class RadialSettingsButton extends StatefulWidget {
  final ThemeController themeController;
  final SidebarController sidebarController;

  const RadialSettingsButton({
    Key? key,
    required this.themeController,
    required this.sidebarController,
  }) : super(key: key);

  @override
  State<RadialSettingsButton> createState() => _RadialSettingsButtonState();
}

class _RadialSettingsButtonState extends State<RadialSettingsButton>
    with SingleTickerProviderStateMixin {
  bool isOpen = false;

  final double radius = 90;

  List<Map<String, dynamic>> get menuItems => [
        {
          'icon': Icons.language,
          'tooltip': 'Language',
          'onPressed': () => _showLanguageDialog(),
        },
        {
          'icon': widget.themeController.themeMode.value == ThemeMode.dark
              ? Icons.light_mode
              : Icons.dark_mode,
          'tooltip': 'Toggle Theme',
          'onPressed': () => widget.themeController.toggleTheme(),
        },
        {
          'icon': Icons.info_outline,
          'tooltip': 'About',
          'onPressed': () => showAboutDialog(
                context: context,
                applicationName: 'Medilink',
                applicationVersion: '1.0.0',
                children: const [Text("© 2025 Medilink")],
              ),
        },
      ];

  Offset getItemPosition(int index, int total) {
    final angle = (2 * pi * index) / total - pi / 2;
    final x = radius * cos(angle);
    final y = radius * sin(angle);
    return Offset(x, y);
  }

  void _showLanguageDialog() {
    Get.defaultDialog(
      title: "Choose Language",
      content: Column(
        children: [
          TextButton(
            onPressed: () {
              Get.updateLocale(const Locale("ar"));
              Get.back();
            },
            child: const Text("العربية"),
          ),
          TextButton(
            onPressed: () {
              Get.updateLocale(const Locale("en"));
              Get.back();
            },
            child: const Text("English"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 230,
      height: 230,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          if (isOpen)
            Container(
              width: 230,
              height: 230,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.primary.withOpacity(0.2),
              ),
            ),

          // العناصر الشعاعية
          ...List.generate(menuItems.length, (index) {
            final pos = getItemPosition(index, menuItems.length);
            return AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              left: isOpen ? 115 + pos.dx : 115,
              top: isOpen ? 115 + pos.dy : 115,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: isOpen ? 1 : 0,
                child: FloatingActionButton(
                  heroTag: null,
                  mini: true,
                  backgroundColor: Theme.of(context).primaryColor,
                  tooltip: menuItems[index]['tooltip'],
                  onPressed: () {
                    setState(() => isOpen = false);
                    menuItems[index]['onPressed']();
                  },
                  child: Icon(menuItems[index]['icon'], size: 18),
                ),
              ),
            );
          }),

          // زر الإعدادات الرئيسي
          Align(
            alignment: Alignment.centerLeft,
            child: FloatingActionButton(
              backgroundColor: AppColor.primary,
              tooltip: 'Settings',
              onPressed: () => setState(() => isOpen = !isOpen),
              child: AnimatedRotation(
                turns: isOpen ? 0.5 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: const Icon(Icons.settings),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
