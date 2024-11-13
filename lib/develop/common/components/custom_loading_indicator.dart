import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nero_app/app_colors.dart';

class CustomLoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitFadingFour(
        color: AppColors.primaryTextColor,
        size: 25.0,
      ),
    );
  }
}