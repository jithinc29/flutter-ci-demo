import 'package:flutter/material.dart';

class AuthNavigationLink extends StatelessWidget {
  const AuthNavigationLink({
    super.key,
    required this.prefixText,
    required this.linkText,
    required this.onTap,
    this.color,
  });

  final String prefixText;
  final String linkText;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final linkColor = color ?? Theme.of(context).primaryColor;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          prefixText,
          style: TextStyle(color: Colors.grey.shade600),
        ),
        TextButton(
          onPressed: onTap,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8),
          ),
          child: Text(
            linkText,
            style: TextStyle(
              color: linkColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
