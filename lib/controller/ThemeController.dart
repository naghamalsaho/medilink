import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  Rx<ThemeMode> themeMode = ThemeMode.light.obs;

  /// دالة تهيئة تقرأ من الـ SharedPreferences
  Future<ThemeController> init() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDarkMode') ?? false;
     print('🔍 [ThemeController] isDarkMode from SharedPreferences = $isDark');
    themeMode.value = isDark ? ThemeMode.dark : ThemeMode.light;
    return this;
  }
  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDarkMode') ?? false;
    themeMode.value = isDark ? ThemeMode.dark : ThemeMode.light;
  }

 void toggleTheme() async {
  final prefs = await SharedPreferences.getInstance();

  if (themeMode.value == ThemeMode.dark) {
    themeMode.value = ThemeMode.light;
    await prefs.setBool('isDarkMode', false);
    print('🔄 [ThemeController] set isDarkMode = false');
  } else {
    themeMode.value = ThemeMode.dark;
    await prefs.setBool('isDarkMode', true);
    print('🔄 [ThemeController] set isDarkMode = true');
  }
}

}
