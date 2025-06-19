import 'package:flutter/material.dart';
import 'package:medilink/core/constants/AppColor.dart';

class Themes {
  // Light Theme
  static final ThemeData customLightTheme = ThemeData.light().copyWith(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF5F5F5), // Light grey background
    appBarTheme: AppBarTheme(
      color: AppColor.primary,
      iconTheme: IconThemeData(color: Colors.black),
    ),
    colorScheme: ColorScheme.light(
      primary: AppColor.primary,
      secondary: AppColor.praimaryColor,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontFamily: "Gafata",
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: Colors.black,
      ),
      displayMedium: TextStyle(
        fontFamily: "Gafata",
        fontWeight: FontWeight.bold,
        fontSize: 26,
        color: Colors.black,
      ),
      displaySmall: TextStyle(
        fontFamily: "Gafata",
        fontWeight: FontWeight.bold,
        fontSize: 30,
        color: Colors.black,
      ),
      bodyLarge: TextStyle(
        fontFamily: "Gafata",
        height: 2,
        fontSize: 14,
        color: Colors.black,
      ),
      bodyMedium: TextStyle(
        fontFamily: "Gafata",
        height: 2,
        fontSize: 14,
        color: Colors.grey[800],
      ),
    ),
    iconTheme: IconThemeData(color: Colors.black),
  );

  // Dark Theme
  static final ThemeData customDarkTheme = ThemeData.dark().copyWith(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColor.backgroundColor,
    appBarTheme: AppBarTheme(
      color: AppColor.primary,
      iconTheme: IconThemeData(color: Colors.white),
    ),
    colorScheme: ColorScheme.dark(
      primary: AppColor.praimaryColor,
      secondary: AppColor.praimaryColor,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontFamily: "Gafata",
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: Colors.white,
      ),
      displayMedium: TextStyle(
        fontFamily: "Gafata",
        fontWeight: FontWeight.bold,
        fontSize: 26,
        color: Colors.white,
      ),
      displaySmall: TextStyle(
        fontFamily: "Gafata",
        fontWeight: FontWeight.bold,
        fontSize: 30,
        color: Colors.white,
      ),
      bodyLarge: TextStyle(
        fontFamily: "Gafata",
        height: 2,
        fontSize: 14,
        color: Colors.white,
      ),
      bodyMedium: TextStyle(
        fontFamily: "Gafata",
        height: 2,
        fontSize: 14,
        color: Colors.grey[300],
      ),
    ),
    iconTheme: IconThemeData(color: Colors.white),
  );
}
