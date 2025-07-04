import 'package:flutter/material.dart';

class ReusableCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final double borderRadius;
  final double elevation;

  const ReusableCard({
    Key? key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    this.margin = EdgeInsets.zero,
    this.borderRadius = 12,
    this.elevation = 2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      elevation: elevation,
      margin: margin,
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}