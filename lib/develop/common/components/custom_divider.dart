import 'package:flutter/material.dart';
import 'package:nero_app/app_colors.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 8,
      color: AppColors.dividerColor,
    );
  }
}
