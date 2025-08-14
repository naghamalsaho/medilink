import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink/controller/PatientsController.dart';
import 'package:medilink/view/widget/PatientsPage/PatientsTable.dart';
import 'package:medilink/view/widget/PatientsPage/filter_bar.dart';
import 'package:medilink/view/widget/PatientsPage/header_bar.dart';

class PatientsPage extends StatelessWidget {
  PatientsPage({super.key});


  final PatientsController patientsController = Get.put(PatientsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HeaderBar(),
            const SizedBox(height: 16),
            const FilterBar(),
            const SizedBox(height: 24),
            
            Expanded(
              child: GetBuilder<PatientsController>(
                builder: (controller) {
                  
                  return PatientsTable();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}