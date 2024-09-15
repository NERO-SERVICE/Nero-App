import 'package:flutter/material.dart';
import 'package:nero_app/develop/common/components/app_font.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.8),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(strokeWidth: 1),
            SizedBox(height: 20),
            AppFont(
              '로딩 중...',
              color: Colors.white,
              size: 18,
            )
          ],
        ),
      ),
    );
  }
}
