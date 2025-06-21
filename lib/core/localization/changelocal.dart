import 'dart:ui';

import 'package:get/get.dart';

import '../services/MyServices.dart';

class LocalController extends GetxController {
  Locale? language;
  MyServices myServices = Get.find();

  void changeLanguage(String languageCode) {
    Locale locale = Locale(languageCode);
    myServices.box.write("lang", languageCode);
    Get.updateLocale(locale);
  }

  @override
  void onInit() {
    super.onInit();

    // قراءة اللغة المحفوظة أو اللغة الحالية للجهاز
    String? boxLanguage = myServices.box.read("lang");
    if (boxLanguage == "ar") {
      language = const Locale("ar");
    } else if (boxLanguage == "en") {
      language = const Locale("en");
    } else {
      language = Locale(Get.deviceLocale?.languageCode ?? "en");
    }

    // حفظ اللغة الحالية إذا لم تكن محفوظة مسبقًا
    myServices.box.write("lang", language!.languageCode);
    Get.updateLocale(language!);
  }
}
