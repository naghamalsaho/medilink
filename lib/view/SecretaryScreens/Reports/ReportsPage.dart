import 'package:flutter/material.dart';
import 'package:medilink/view/widget/Reports/BestDoctorsSection.dart';
import 'package:medilink/view/widget/Reports/FilterDropdown.dart';
import 'package:medilink/view/widget/Reports/HeaderSection.dart';
import 'package:medilink/view/widget/Reports/PerformanceSummarySection.dart';
class ReportsPage extends StatelessWidget {
  const ReportsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(             // ← هنا
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HeaderSection(),
              const SizedBox(height: 16),
              FilterSection(),
              const SizedBox(height: 24),
              const StatisticsGrid(),
              const SizedBox(height: 24),
              const BestDoctorsSection(),
              const SizedBox(height: 24),
              const PerformanceSummarySection(),
            ],
          ),
        ),
      ),
    );
  }
}
