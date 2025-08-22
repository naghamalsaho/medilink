import 'package:flutter/material.dart';

class AdminWelcomeBanner extends StatelessWidget {
  const AdminWelcomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.purple,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.favorite, color: Colors.white, size: 36),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Welcome to the Medical Center Management',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Icon(Icons.arrow_outward, color: Colors.white, size: 28),
        ],
      ),
    );
  }
}
