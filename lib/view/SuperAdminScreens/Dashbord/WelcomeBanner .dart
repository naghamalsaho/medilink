import 'package:flutter/material.dart';

class SuperAdminWelcomeBanner extends StatelessWidget {
  const SuperAdminWelcomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF00ACC1), // أخضر فاتح لطيف قريب للأزرق
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.health_and_safety, color: Colors.white, size: 36),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              "Welcome to the Ministry of Health System",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
