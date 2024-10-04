import 'package:flutter/material.dart';
import 'package:nero_app/develop/common/components/app_font.dart';
import 'package:nero_app/develop/common/components/custom_loading_indicator.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.8),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomLoadingIndicator(),
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
