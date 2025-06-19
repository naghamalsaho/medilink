import 'package:flutter/material.dart';
import 'package:medilink/core/constants/AppColor.dart';


class SplashBackground extends StatelessWidget {
  final Widget child;

  const SplashBackground({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 0.85,
            colors: [AppColor.bgLight, Colors.white],
            stops: [0, 1],
          ),
        ),
        child: child,
      ),
    );
  }
}