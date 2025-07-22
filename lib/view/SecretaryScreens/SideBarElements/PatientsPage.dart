// main PatientsPage class
import 'package:flutter/material.dart';
import 'package:medilink/view/widget/PatientsPage/PatientsTable.dart';
import 'package:medilink/view/widget/PatientsPage/filter_bar.dart';
import 'package:medilink/view/widget/PatientsPage/header_bar.dart';

class PatientsPage extends StatelessWidget {
  const PatientsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            HeaderBar(),
            SizedBox(height: 16),
            FilterBar(),
            SizedBox(height: 24),
            Expanded(child: PatientsTable()),
          ],
        ),
      ),
    );
  }
}
