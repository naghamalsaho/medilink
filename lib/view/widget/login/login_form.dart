import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart' show Get;
import 'package:get/instance_manager.dart';
import 'package:medilink/controller/auth/loginController.dart';
import 'package:medilink/core/class/statusrequest.dart';
import 'package:medilink/core/constants/AppColor.dart';
import 'package:medilink/core/functions/validinput.dart';
import 'package:get/get.dart';
import 'package:medilink/view/widget/auth/CusomButtomAuth.dart';
import 'package:medilink/view/widget/auth/Customtextformauth.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({Key? key}) : super(key: key);

  get controller => null;

  @override
  Widget build(BuildContext context) {
    LoginControllerImp controller = Get.put(LoginControllerImp());
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

          Text(
            'Welcome!',
            style: TextStyle(
              fontFamily: 'Cairo', // تأكد أن الخط معرف
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 48),
          DropdownButtonFormField<String>(
            value: controller.selectedRole,
            decoration: InputDecoration(
              labelText: 'Select Role',
              filled: true,
              fillColor: Colors.grey[100],
              prefixIcon: const Icon(Icons.security_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Select Role';
              }
              return null;
            },
            items:
                [
                  {'label': 'secretary', 'value': 'secretary'},
                  {'label': 'admin', 'value': 'admin'},
                  {'label': 'super_admin', 'value': 'super_admin'},
                ].map((roleMap) {
                  return DropdownMenuItem(
                    value: roleMap['value'],
                    child: Text(roleMap['label']!),
                  );
                }).toList(),
            onChanged: (val) {
              controller.selectedRole = val!;
            },
          ),
          const SizedBox(height: 16),

          Customtextformauth(
            valid: (val) {
              return validInput(val!, 5, 100, "email");
            },
            iconData: Icons.email_outlined,
            labeltext: "Enter Your Email",
            mycontroller: controller.loginController,
            type: "email",
          ),
          const SizedBox(height: 16),
          Customtextformauth(
            valid: (val) {
              return validInput(val!, 5, 30, "password");
            },
            iconData: Icons.lock_outlined,
            labeltext: "Enter Your Password",
            mycontroller: controller.passwordController,
            type: "password",
          ),

          /// 🔽 Dropdown لاختيار الرول
          const SizedBox(height: 24),
          CustomButtomAuth(
            text: "Sign In",
            icon: Icons.verified_user,

            onPressed: () {
              if (controller.statusRequest != StatusRequest.loading) {
                controller.login();
              }
            },
          ),
        ],
      ),
    );
  }
}