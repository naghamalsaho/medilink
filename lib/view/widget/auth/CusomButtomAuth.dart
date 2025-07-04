import 'package:flutter/material.dart';
import 'package:medilink/core/constants/AppColor.dart';

class CustomButtomAuth extends StatelessWidget {
  final String text;
  final IconData? icon; // ← أضفنا هذا السطر

  final void Function()? onPressed;

  const CustomButtomAuth({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // ياخد عرض الشاشة بالكامل
      height: 50, // نفس ارتفاع الحقول
      child: ElevatedButton(
        onPressed: onPressed,

        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20, color: Colors.white),
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

}
