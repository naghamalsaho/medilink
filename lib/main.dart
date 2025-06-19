import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink/controller/ThemeController.dart';
import 'package:medilink/view/screen/HomePage.dart';
import 'package:medilink/core/constants/Themes.dart';
import 'package:medilink/view/screen/MainLayout.dart';
import 'package:medilink/view/widget/Sidebar.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // أولًا: تهيئة ThemeController والـ SharedPreferences
  await Get.putAsync<ThemeController>(() => ThemeController().init());

  // ثانيًا: تسجيل SidebarController كي يُصبح متاحًا للعثور عليه
  Get.put(SidebarController());

  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();

    return Obx(() => GetMaterialApp(
          title: 'Flutter Web Sidebar',
          debugShowCheckedModeBanner: false,
          theme: Themes.customLightTheme,
          darkTheme: Themes.customDarkTheme,
          themeMode: themeController.themeMode.value,
          home: MainLayout(),
        ));
  }
}

