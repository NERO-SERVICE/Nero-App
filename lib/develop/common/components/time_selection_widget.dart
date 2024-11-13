import 'package:animated_button_bar/animated_button_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nero_app/app_colors.dart';

class TimeSelectionWidget extends StatefulWidget {
  final RxString selectedTime;

  TimeSelectionWidget({required this.selectedTime});

  @override
  _TimeSelectionWidgetState createState() => _TimeSelectionWidgetState();
}

class _TimeSelectionWidgetState extends State<TimeSelectionWidget> {
  final AnimatedButtonController _controller = AnimatedButtonController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '복용시간',
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: AppColors.titleColor,
          ),
        ),
        const SizedBox(height: 20),
        Obx(() {
          return AnimatedButtonBar(
            controller: _controller,
            radius: 16.0,
            backgroundColor: AppColors.inactiveButtonColor,
            foregroundColor: AppColors.primaryColor,
            innerVerticalPadding: 16,
            children: [
              ButtonBarEntry(
                onTap: () {
                  setState(() {
                    widget.selectedTime.value = '아침';
                  });
                },
                child: Text(
                  '아침',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: widget.selectedTime.value == '아침'
                        ? AppColors.buttonSelectedTextColor
                        : AppColors.titleColor,
                  ),
                ),
              ),
              ButtonBarEntry(
                onTap: () {
                  setState(() {
                    widget.selectedTime.value = '점심';
                  });
                },
                child: Text(
                  '점심',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: widget.selectedTime.value == '점심'
                        ? AppColors.buttonSelectedTextColor
                        : AppColors.titleColor,
                  ),
                ),
              ),
              ButtonBarEntry(
                onTap: () {
                  setState(() {
                    widget.selectedTime.value = '저녁';
                  });
                },
                child: Text(
                  '저녁',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: widget.selectedTime.value == '저녁'
                        ? AppColors.buttonSelectedTextColor
                        : AppColors.titleColor,
                  ),
                ),
              ),
            ],
          );
        }),
      ],
    );
  }
}
