import 'package:flutter/material.dart';

class CustomCommunityDivider extends StatelessWidget {
  const CustomCommunityDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 1,
      color: const Color(0xFF959595).withOpacity(0.1),
    );
  }
}
