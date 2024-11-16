import 'package:flutter/material.dart';
import 'package:nero_app/app_colors.dart';

class CustomSubmitButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isEnabled;
  final String text;
  final Color? backgroundColor;

  const CustomSubmitButton({
    Key? key,
    required this.onPressed,
    this.isEnabled = true,
    this.text = "제출하기",
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isEnabled ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: isEnabled
            ? (backgroundColor ?? AppColors.activeButtonColor)
            : AppColors.inactiveButtonColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 33),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: AppColors.titleColor,
        ),
      ),
    );
  }
}
