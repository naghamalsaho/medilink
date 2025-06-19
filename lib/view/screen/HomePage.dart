import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink/controller/ThemeController.dart';
import 'package:medilink/view/widget/Sidebar.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
       final themeController = Get.find<ThemeController>();
    return Scaffold(
      body: Row(
        children: [
          Sidebar(),
 // أصبح بدون باراميتر
          Expanded(
            child: Container(
              padding: EdgeInsets.all(24),
              child: Center(
                child: Text(
                  'Welcome to the Dashboard',
                  style: TextStyle(
                    fontSize: 24,
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}