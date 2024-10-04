import 'package:flutter/material.dart';

class CustomCompleteButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isEnabled;
  final String text;

  const CustomCompleteButton({
    Key? key,
    required this.onPressed,
    this.isEnabled = true,
    this.text = "선택하기",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isEnabled ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: isEnabled ? Color(0xff1C1B1B) : Color(0xff3C3C3C),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 33),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w500,
          fontSize: 16,
          color: Color(0xffD0EE17),
        ),
      ),
    );
  }
}
