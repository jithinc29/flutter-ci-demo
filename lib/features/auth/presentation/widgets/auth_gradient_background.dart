import 'package:flutter/material.dart';

class AuthGradientBackground extends StatelessWidget {
  const AuthGradientBackground({
    super.key,
    required this.child,
    this.colors,
  });

  final Widget child;
  final List<Color>? colors;

  @override
  Widget build(BuildContext context) {
    final defaultColors = [
      Colors.blue.shade50,
      Colors.purple.shade50,
      Colors.white,
    ];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors ?? defaultColors,
        ),
      ),
      child: child,
    );
  }
}
