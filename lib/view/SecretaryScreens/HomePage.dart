import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink/controller/ThemeController.dart';
import 'package:medilink/core/responsive_layout.dart';
import 'package:medilink/core/screen_helper.dart';
import 'package:medilink/view/widget/home/SecretarySidebar.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return ResponsiveLayout(
      mobile: HomePageMobile(themeController: themeController),
      tablet: HomePageDesktop(themeController: themeController),
      desktop: HomePageDesktop(themeController: themeController),
    );
  }
}

class HomePageMobile extends StatelessWidget {
  final ThemeController themeController;
  const HomePageMobile({Key? key, required this.themeController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medilink'),
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        // actions: [
        //   // مثال لاستخدام themeController
        //   IconButton(
        //     icon: Icon(themeController.themeMode.value == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode),
        //     onPressed: () => themeController.changeTheme(), // افترض عندك method لتغيير الثيم
        //   ),
        // ],
      ),
      drawer: Drawer(
        child: SafeArea(child: SecretarySidebar()), // تستعمل الـ Sidebar داخل Drawer
      ),
      body: const SafeArea(
        child: Center(
          child: Text('مرحبا — نسخة الموبايل', textAlign: TextAlign.center),
        ),
      ),
    );
  }
}

class HomePageDesktop extends StatelessWidget {
  final ThemeController themeController;
  const HomePageDesktop({Key? key, required this.themeController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // الشريط الجانبي ثابت على الواجهة الكبيرة
           SizedBox(width: 280, child: SecretarySidebar()),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Text(
                  'Welcome to the Dashboard',
                  style: TextStyle(
                    fontSize: 24,
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
