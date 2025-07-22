import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink/core/class/handlingdataview.dart';
import 'package:medilink/core/class/statusrequest.dart';
import 'package:medilink/core/functions/handlingdatacontroller.dart';
import 'package:medilink/data/datasourse/remot/auth/login.dart';
import 'package:medilink/view/SecretaryScreens/HomePage.dart';
import 'package:medilink/view/widget/home/MainHealth.dart';
import 'package:medilink/view/widget/home/MainSecretary.dart' as AppRoute;

abstract class LoginController extends GetxController {
  login();
  goToHomePage();
}

class LoginControllerImp extends LoginController {
  // Controllers
  final loginController =
      TextEditingController(); // login: could be email or phone
  final passwordController = TextEditingController();

  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  StatusRequest statusRequest = StatusRequest.none;
  LoginData loginData = LoginData(Get.find());
  List data = [];

  @override
  Future<void> login() async {
    if (formstate.currentState!.validate()) {
      statusRequest = StatusRequest.loading;
      update();

      try {
        final response = await loginData.postData(
          loginController.text,
          passwordController.text,
        );
        if (response['success'] == true) {
          final role = response['data']['role'];
          switch (role) {
            case 'secretary':
              Get.offAll(() => AppRoute.MainSecretary()); // واجهة وزارة الصحة
              break;
            case 'super_admin':
              Get.offAll(() => MainHealth()); // واجهة المستشفى
              break;
            default:
              Get.offAll(() => HomePage()); // واجهة افتراضية
          }
        } else {
          Get.defaultDialog(
            title: "خطأ",
            middleText: response['message'] ?? "بيانات الدخول غير صحيحة",
          );
        }

        print(
          "RESPONSE TYPE: ${response.runtimeType}",
        ); // للتأكد من نوع البيانات
        print("FULL RESPONSE: $response");

        // if (response['success'] == true) {
        //   // الانتقال المباشر للصفحة التالية
        //   Get.offAll(
        //     () => AppRoute.MainLayout(),
        //   ); // استبدل HomePage بصفحتك الفعلية
        // }
      } catch (e) {
        print("CATCHED ERROR: $e");
        Get.defaultDialog(title: "خطأ", middleText: "تعذر الاتصال بالسيرفر");
      } finally {
        statusRequest = StatusRequest.none;
        update();
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    loginController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  @override
  goToHomePage() {
    // للانتقال للصفحة الرئيسية بعد تسجيل الدخول
    Get.to(() => AppRoute.MainSecretary());
  }
}
