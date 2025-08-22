import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink/core/class/handlingdataview.dart';
import 'package:medilink/core/class/statusrequest.dart';
import 'package:medilink/core/functions/handlingdatacontroller.dart';
import 'package:medilink/core/services/MyServices.dart';
import 'package:medilink/data/datasourse/remot/auth/login.dart';
import 'package:medilink/view/SecretaryScreens/HomePage.dart';
import 'package:medilink/view/widget/home/MainAdminCenter.dart';
import 'package:medilink/view/widget/home/MainHealth.dart';
import 'package:medilink/view/widget/home/MainSecretary.dart' as AppRoute;

abstract class LoginController extends GetxController {
  login();
  goToHomePage();
}

class LoginControllerImp extends LoginController {
  // Controllers
  String? selectedRole;
  final loginController = TextEditingController();
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
          selectedRole ?? "",
        );

        if (response != null && response['success'] == true) {
          final data = response['data'];
          final box = Get.find<MyServices>().box;

          /// حفظ التوكينات
          box.write("token", data['access_token']);
          box.write("refresh_token", data['refresh_token']);
          box.write("token_type", data['token_type']);
          box.write("role", data['role']);

          /// حفظ بيانات المستخدم
          if (data['user'] != null) {
            box.write("user_id", data['user']['id']);
            box.write("user_name", data['user']['name']);
          }

          print("=== TOKEN STORED === ${box.read('token')}");
          print("=== ROLE STORED === ${box.read('role')}");

          final role = data['role'];
          switch (role) {
            case 'secretary':
              Get.offAll(() => AppRoute.MainSecretary());
              break;
            case 'super_admin':
              Get.offAll(() => MainHealth());
              break;
            case 'center_admin':
              Get.offAll(() => MainAdminCenter());
              break;
            default:
              Get.offAll(() => MainAdminCenter());
          }
        } else {
          Get.defaultDialog(
            title: "خطأ",
            middleText:
                response?['message'] ?? "The login information is incorrect.",
          );
        }

        print("FULL RESPONSE: $response");
      } catch (e) {
        print("CATCHED ERROR: $e");
        Get.defaultDialog(
          title: "خطأ",
          middleText: "Unable to connect to server",
        );
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
    Get.to(() => AppRoute.MainSecretary());
  }
}
