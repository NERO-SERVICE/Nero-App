import 'package:flutter/material.dart';
import 'package:nero_app/app_colors.dart';

class Btn extends StatelessWidget {
  final Widget child;
  final Function() onTap;
  final EdgeInsets padding;
  final Color color;
  final bool disabled;
  final ShapeBorder? shape;

  const Btn({
    super.key,
    required this.child,
    required this.onTap,
    this.disabled = false,
    this.color = AppColors.primaryColor,
    this.padding = const EdgeInsets.symmetric(vertical: 15, horizontal: 41),
    this.shape,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!disabled) {
          onTap();
        }
      },
      child: ClipRRect(
        borderRadius: shape != null && shape is RoundedRectangleBorder
            ? (shape as RoundedRectangleBorder).borderRadius
            : BorderRadius.circular(7),
        child: Container(
          padding: padding,
          decoration: ShapeDecoration(
            color: disabled ? AppColors.inactiveButtonColor : color,
            shape: shape ??
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
          ),
          child: child,
        ),
      ),
    );
  }
}