import 'package:flutter/material.dart';

class ContentEmphasizeWidget extends StatelessWidget {
  final String content;

  const ContentEmphasizeWidget({required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: RichText(
        text: TextSpan(
          children: _parseContent(content),
        ),
      ),
    );
  }

  List<TextSpan> _parseContent(String content) {
    final List<TextSpan> spans = [];
    final regex = RegExp(r'!!.*?!!|@@.*?@@|##.*?##|\$\$.*?\$\$|%%.*?%%|\^\^.*?\^\^');
    final matches = regex.allMatches(content);
    int currentIndex = 0;

    for (final match in matches) {
      if (currentIndex < match.start) {
        spans.add(TextSpan(
          text: content.substring(currentIndex, match.start),
          style: const TextStyle(
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Color(0xffD9D9D9),
          ),
        ));
      }

      final matchedText = match.group(0)!;
      final cleanText = matchedText.substring(2, matchedText.length - 2); // 감싸는 기호 제거

      TextStyle style;
      if (matchedText.startsWith('!!')) {
        style = const TextStyle(
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: Color(0xffFFFFFF),
        );
      } else if (matchedText.startsWith('@@')) {
        style = const TextStyle(
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: Color(0xffD0EE17),
        );
      } else if (matchedText.startsWith('##')) {
        style = const TextStyle(
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: Color(0xffFFFFFF),
        );
      } else if (matchedText.startsWith('\$\$')) {
        style = const TextStyle(
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: Color(0xffD0EE17),
        );
      } else if (matchedText.startsWith('%%')) {
        style = const TextStyle(
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w600,
          fontSize: 18,
          color: Color(0xffFFFFFF),
        );
      } else if (matchedText.startsWith('^^')) {
        style = const TextStyle(
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w600,
          fontSize: 18,
          color: Color(0xffD0EE17),
        );
      } else {
        style = const TextStyle(
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w500,
          fontSize: 14,
          color: Color(0xffD9D9D9),
        );
      }

      spans.add(TextSpan(
        text: cleanText,
        style: style,
      ));

      currentIndex = match.end;
    }

    if (currentIndex < content.length) {
      spans.add(TextSpan(
        text: content.substring(currentIndex),
        style: const TextStyle(
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w500,
          fontSize: 14,
          color: Color(0xffD9D9D9),
        ),
      ));
    }

    return spans;
  }
}
