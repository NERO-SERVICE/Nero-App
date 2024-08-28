import 'package:flutter/material.dart';

class BackgroundLayout extends StatelessWidget {
  final Widget child;
  BackgroundLayout({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1C1B1B),
      child: child,
    );
  }
}