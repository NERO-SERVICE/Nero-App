import 'package:flutter/material.dart';

class CustomSnackbar {
  static void show({
    required BuildContext context,
    required String message,
    required bool isSuccess,
  }) {
    final snackBar = SnackBar(
      content: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xff202020),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: isSuccess ? Colors.white : Colors.red,
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      elevation: 0, // 그림자 제거
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
