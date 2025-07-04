import 'package:flutter/material.dart';

class FilterDropdown extends StatelessWidget {
  final String label;
  const FilterDropdown({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Text(label),
          const SizedBox(width: 4),
          const Icon(Icons.keyboard_arrow_down, size: 20),
        ],
      ),
    );
  }
}

// Grid of statistic cards
class StatisticsGrid extends StatelessWidget {
  const StatisticsGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        StatisticsCard(title: 'معدل الحضور', value: '93.2%', footer: '+2.1% من الشهر الماضي', icon: Icons.show_chart, color: Colors.purple),
        StatisticsCard(title: 'إجمالي المواعيد', value: '367', footer: '342 مكتمل', icon: Icons.calendar_today, color: Colors.green),
        StatisticsCard(title: 'إجمالي المرضى', value: '1,248', footer: '+52 مريض جديد', icon: Icons.people, color: Colors.blue),
      ],
    );
  }
}

// Single statistic card
class StatisticsCard extends StatelessWidget {
  final String title;
  final String value;
  final String footer;
  final IconData icon;
  final Color color;

  const StatisticsCard({
    Key? key,
    required this.title,
    required this.value,
    required this.footer,
    required this.icon,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w500)), Icon(icon, color: color)],
              ),
              const SizedBox(height: 12),
              Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
              const SizedBox(height: 8),
              Text(footer, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}