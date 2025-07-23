import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:medilink/controller/auth/test_controller.dart';
import 'package:medilink/core/class/statusrequest.dart';

class TestView extends StatelessWidget {
  const TestView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(TestController());
    return Scaffold(
      appBar: AppBar(title: Text("Title")),
      body: GetBuilder<TestController>(
        builder: (controller) {
          if (controller.statusRequest == StatusRequest.loading) {
            return const Center(child: Text("Loading"));
          } else if (controller.statusRequest == StatusRequest.offlinefailure) {
            return const Center(child: Text("Offline Failure"));
          } else if (controller.statusRequest == StatusRequest.serverfailure) {
            return const Center(child: Text("Server Failure"));
          } else if (controller.statusRequest == StatusRequest.failure) {
            return const Center(child: Text(" No Data"));
          } else {
            return ListView.builder(
              itemCount: controller.data.length,
              itemBuilder: (context, index) {
                return Text("${controller.data}");
              },
            );
          }
        },
      ),
    );
  }
}
