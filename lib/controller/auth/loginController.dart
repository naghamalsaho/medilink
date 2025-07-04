import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink/view/screen/HomePage.dart' as AppRoute;

abstract class LoginController extends GetxController {
  login();
  goToHomePage();
}

class loginControllerImp extends LoginController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  late TextEditingController email;
  late TextEditingController password;

  @override
  login() {
    var formdata = formstate.currentState;
    if (formdata!.validate()) {
      print("Valid");
    } else {
      print("Not Valid");
    }
    if (email == 'admin@medilink.com' && password == '123456') {
      Get.to(() => AppRoute.HomePage()); // نجاح → انتقل إلى الصفحة الرئيسية
    } else {
      Get.snackbar(
        'Login Failed',
        'Email or password is incorrect',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  @override
  goToHomePage() {
    Get.toNamed(AppRoute.HomePage as String);
  }

  @override
  void onInit() {
    email = TextEditingController();
    password = TextEditingController();

    super.onInit();
  }

  @override
  void onClose() {
    void dispose() {
      email.dispose();
      password.dispose();
      super.dispose();
    }
  }
}