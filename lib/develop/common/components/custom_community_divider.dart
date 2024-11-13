import 'package:flutter/material.dart';
import 'package:nero_app/app_colors.dart';

class CustomCommunityDivider extends StatelessWidget {
  const CustomCommunityDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 1,
      color: AppColors.communityDividerColor,
    );
  }
}
