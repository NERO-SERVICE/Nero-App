import 'package:flutter/material.dart';

class BackgroundLayout extends StatelessWidget {
  final Widget child;
  BackgroundLayout({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: child,
    );
  }
}
