import 'package:flutter/material.dart';
import 'package:animated_button_bar/animated_button_bar.dart';
import 'package:get/get.dart';

class TimeSelectionWidget extends StatefulWidget {
  final RxString selectedTime;

  TimeSelectionWidget({required this.selectedTime});

  @override
  _TimeSelectionWidgetState createState() => _TimeSelectionWidgetState();
}

class _TimeSelectionWidgetState extends State<TimeSelectionWidget> {
  final AnimatedButtonController _controller = AnimatedButtonController();

  @override
  void dispose() { // 메모리 누수 방지
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '복용시간',
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 18),
        Obx(() {
          return AnimatedButtonBar(
            controller: _controller,
            radius: 16.0,
            backgroundColor: Color(0xffD9D9D9).withOpacity(0.5),
            foregroundColor: Color(0xffD0EE17),
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
                    fontSize: 16,
                    color: widget.selectedTime.value == '아침'
                        ? Colors.black
                        : Colors.white,
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
                    fontSize: 16,
                    color: widget.selectedTime.value == '점심'
                        ? Colors.black
                        : Colors.white,
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
                    fontSize: 16,
                    color: widget.selectedTime.value == '저녁'
                        ? Colors.black
                        : Colors.white,
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
