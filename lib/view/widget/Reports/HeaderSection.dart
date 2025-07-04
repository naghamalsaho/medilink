import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medilink/view/widget/Reports/FilterDropdown.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('التقارير والإحصائيات', style: theme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text('تحليل شامل لأداء المركز الطبي', style: theme.titleMedium?.copyWith(color: Colors.grey[600])),
      ],
    );
  }
}
class FilterSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          // 1) Export button
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.download_rounded),
            label: const Text("تصدير التقرير"),
          ),

          const SizedBox(width: 16),

          // 2) Date picker
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: OutlinedButton.icon(
                onPressed: () {},
                icon:  Icon(Icons.calendar_today_outlined),
                label: Text(DateFormat('MM/dd/yyyy').format(DateTime.now())),
              ),
            ),
          ),

          const SizedBox(width: 16),

          // 3) Status filter dropdown
          DropdownButton<String>(
            value: 'نظرة عامة',
            items: ['نظرة عامة', 'متابعة', 'نجاح']
                .map((label) => DropdownMenuItem(
                      value: label,
                      child: Text(label),
                    ))
                .toList(),
            onChanged: (_) {},
          ),

          // 4) Spacer pushes search to right
          const Spacer(),

          // 5) Search field
          SizedBox(
            width: 250,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'بحث بالاسم، مريض، موعد أو ملف...',
                prefixIcon: const Icon(Icons.search_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
              ),
              onSubmitted: (query) {
                // TODO: wire up your search logic
              },
            ),
          ),
        ],
      ),
    );
  }
}
