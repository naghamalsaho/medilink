import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink/controller/ThemeController.dart';
import 'package:medilink/core/localization/changelocal.dart';
import 'package:medilink/core/localization/translation.dart';
import 'package:medilink/core/services/MyServices.dart';
import 'package:medilink/view/screen/HomePage.dart';
import 'package:medilink/core/constants/Themes.dart';
import 'package:medilink/view/widget/home/MainLayout.dart';
import 'package:medilink/view/widget/home/Sidebar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ تهيئة MyServices
  await Get.putAsync<MyServices>(() => MyServices().init());

  // ✅ ThemeController
  await Get.putAsync<ThemeController>(() => ThemeController().init());

  // ✅ LocalController
  Get.put(LocalController());

  // ✅ SidebarController
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
           translations: MyTranslation(), // 🔸 ربط الترجمة
  locale: Get.find<LocalController>().language, // 🔸 اللغة الحالية
  fallbackLocale: const Locale("en"),
          home: MainLayout(),
        ));
  }
}

