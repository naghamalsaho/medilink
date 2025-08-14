import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PerformanceSummarySection extends StatelessWidget {
  const PerformanceSummarySection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        
        Text(
          ' performance summary',
          style: theme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          children: const [
            Expanded(
              child: SummaryCard(
                value: '95%',
                title: 'patient satisfaction ',
                backgroundColor: Color(0xFFE3F2FD),
                valueColor: Color(0xFF1E88E5),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: SummaryCard(
                value: 'min 12',
                title: 'average waiting time ',
                backgroundColor: Color(0xFFE8F5E9),
                valueColor: Color(0xFF43A047),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: SummaryCard(
                value: '4.7/5',
                title: ' service evaluation',
                backgroundColor: Color(0xFFF3E5F5),
                valueColor: Color(0xFF8E24AA),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: SummaryCard(
                value: '24/7',
                title: ' working hours',
                backgroundColor: Color(0xFFFFF3E0),
                valueColor: Color(0xFFF4511E),
              ),
            ),
          ],
        ),
      ],
    );
  }
}


class SummaryCard extends StatelessWidget {
  final String value;
  final String title;
  final Color backgroundColor;
  final Color valueColor;

  const SummaryCard({
    Key? key,
    required this.value,
    required this.title,
    required this.backgroundColor,
    required this.valueColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}