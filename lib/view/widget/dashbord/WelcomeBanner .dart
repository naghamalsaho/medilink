import 'package:flutter/material.dart';

class WelcomeBanner extends StatelessWidget {
  const WelcomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue.shade700,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.favorite, color: Colors.white, size: 36),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Welcom Back ! , Yaman',
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
<<<<<<< HEAD
}
=======
}
>>>>>>> 15f770e076bcf5587254b89510daaed02b8fc611
