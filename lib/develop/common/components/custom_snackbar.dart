import 'package:flutter/material.dart';
import 'package:nero_app/app_colors.dart';

class CustomSnackbar {
  static void show({
    required BuildContext context,
    required String message,
    required bool isSuccess,
  }) {
    final snackBar = SnackBar(
      content: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          color: AppColors.snackBarColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color:
                isSuccess ? AppColors.titleColor : AppColors.deleteButtonColor,
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
