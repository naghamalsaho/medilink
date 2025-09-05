import 'package:flutter/material.dart';

/// ResponsiveLayout: يقرر أي واجهة يعرض (mobile/tablet/desktop)
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget desktop;

  const ResponsiveLayout({
    Key? key,
    required this.mobile,
    Widget? tablet,
    Widget? desktop,
  })  : tablet = tablet ?? mobile,
        desktop = desktop ?? mobile,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final w = constraints.maxWidth;
      if (w >= 1200) {
        return desktop;
      } else if (w >= 600) {
        return tablet;
      } else {
        return mobile;
      }
    });
  }
}
