import 'package:flutter/material.dart';

class BestDoctorsSection extends StatelessWidget {
  const BestDoctorsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [Text('أفضل الأطباء أداءً', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)), const Spacer(), const Text('عرض الكل', style: TextStyle(color: Colors.blue))],
        ),
        const SizedBox(height: 16),
        const DoctorRow(rank: 1, name: 'د. سامي الأحمد', rating: '4.8/5', count: 89),
        const SizedBox(height: 8),
        const DoctorRow(rank: 2, name: 'د. ليلى حسن', rating: '4.9/5', count: 76),
      ],
    );
  }
}

// Single doctor row
class DoctorRow extends StatelessWidget {
  final int rank;
  final String name;
  final String rating;
  final int count;

  const DoctorRow({Key? key, required this.rank, required this.name, required this.rating, required this.count}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(rank.toString(), style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
            Text('$count موعد', style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        const Spacer(),
        Text(rating, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
