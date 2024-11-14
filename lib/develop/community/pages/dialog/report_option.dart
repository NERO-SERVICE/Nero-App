import 'package:flutter/material.dart';
import 'package:nero_app/app_colors.dart';

class ReportOption extends StatelessWidget {
  final String title;
  final String value;
  final bool isSelected;
  final VoidCallback onTap;

  const ReportOption({
    Key? key,
    required this.title,
    required this.value,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        margin: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: isSelected
              ? Color(0xffD0EE17).withOpacity(0.2)
              : Color(0xff1C1B1B),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Color(0xffD0EE17) : Colors.transparent,
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: isSelected
                  ? AppColors.titleColor
                  : AppColors.primaryTextColor,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}