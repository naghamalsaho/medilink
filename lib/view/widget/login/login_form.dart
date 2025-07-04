import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink/controller/auth/loginController.dart';
import 'package:medilink/core/constants/AppColor.dart';
import 'package:medilink/core/functions/validinput.dart';
import 'package:medilink/view/widget/auth/CusomButtomAuth.dart';
import 'package:medilink/view/widget/auth/Customtextformauth.dart';
import 'package:medilink/view/widget/home/MainLayout.dart';
import 'package:medilink/core/constants/routes.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    loginControllerImp controller = Get.put(loginControllerImp());
    return Form(
      key: controller.formstate,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Hero(
            tag: 'heartbeatLogo',
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [AppColor.primary, Colors.cyan],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.teal.withOpacity(0.3),
                    blurRadius: 10,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  '🩺',
                  style: TextStyle(fontSize: 50, color: Colors.white),
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            'Welcome!',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 48),
          Customtextformauth(
            valid: (val) {
              return validInput(val!, 5, 100, "email");
            },
            iconData: Icons.email_outlined,
            labeltext: "Enter Your Email",
            mycontroller: controller.email,
            type: "email",
          ),
          const SizedBox(height: 16),
          Customtextformauth(
            valid: (val) {
              return validInput(val!, 5, 30, "password");
            },
            iconData: Icons.lock_outlined,
            labeltext: "Enter Your Password",
            mycontroller: controller.password,
            type: "password",
          ),
          const SizedBox(height: 24),
          CustomButtomAuth(
            text: "Sign In",
            icon: Icons.verified_user,
            onPressed: () {
              Get.offAll(() => MainLayout());
              // أو: controller.login();
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Get.offNamed(AppRoute.mainLayout);
            },
            child: const Text('Login', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
