import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          ' reports and statisics',
          style: theme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          '   comprehensive analysis for the medical center perfomance ',
          style: theme.titleMedium?.copyWith(color: Colors.grey[600]),
        ),
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
         
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.download_rounded),
            label: const Text(" Export report"),
          ),

          const SizedBox(width: 16),

         
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.calendar_today_outlined),
                label: Text(DateFormat('MM/dd/yyyy').format(DateTime.now())),
              ),
            ),
          ),

          const SizedBox(width: 16),

          DropdownButton<String>(
            value: 'General overvirw ',
            items:
                ['General overvirw ', 'follow', 'successful']
                    .map(
                      (label) =>
                          DropdownMenuItem(value: label, child: Text(label)),
                    )
                    .toList(),
            onChanged: (_) {},
          ),

          
          const Spacer(),

         
          SizedBox(
            width: 250,
            child: TextField(
              decoration: InputDecoration(
                hintText: '     Search by patient name, appointment oe file...',
                prefixIcon: const Icon(Icons.search_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 12,
                ),
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
