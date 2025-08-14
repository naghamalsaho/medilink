import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:medilink/bindings/initialbindinds.dart';
import 'package:medilink/controller/ThemeController.dart';
import 'package:medilink/controller/profileController.dart';
import 'package:medilink/core/class/crud.dart';
import 'package:medilink/core/constants/routes.dart';
import 'package:medilink/core/localization/changelocal.dart';
import 'package:medilink/core/localization/translation.dart';
import 'package:medilink/core/services/MyServices.dart';
import 'package:medilink/core/constants/Themes.dart';
import 'package:medilink/routes.dart';
import 'package:medilink/view/widget/home/SecretarySidebar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  await Get.putAsync<MyServices>(() => MyServices().init());
Get.put(Crud());
 
  await Get.putAsync<ThemeController>(() => ThemeController().init());

  
  Get.put(LocalController());


  Get.put(SidebarController());
  Get.put(ProfileController());
  WidgetsFlutterBinding.ensureInitialized();
  
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();

    return Obx(
      () => GetMaterialApp(
        title: 'Flutter Web Sidebar',
        debugShowCheckedModeBanner: false,
        theme: Themes.customLightTheme,
        darkTheme: Themes.customDarkTheme,
        themeMode: themeController.themeMode.value,
        translations: MyTranslation(), 
        locale: Get.find<LocalController>().language, 
        fallbackLocale: const Locale("en"),
        initialRoute: AppRoute.splash,
        initialBinding: InitialBindings(),
        getPages: appPages,
      ),
    );
  }
}
