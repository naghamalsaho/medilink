import 'package:flutter/material.dart';
import 'package:medilink/core/constants/AppColor.dart';

class AnimatedLogo extends AnimatedWidget {
  final Animation<double> animation;

  const AnimatedLogo({super.key, required this.animation})
    : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Container(
          width: 140 * animation.value,
          height: 140 * animation.value,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [AppColor.primary, Colors.cyan],

              radius: 0.6,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColor.primary.withOpacity(0.6 * animation.value),
                blurRadius: 30 * animation.value,
                spreadRadius: 1.5,
              ),
            ],
          ),
          child: const Center(
            child: Text(
              '🩺',
              style: TextStyle(
                fontSize: 70,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}
