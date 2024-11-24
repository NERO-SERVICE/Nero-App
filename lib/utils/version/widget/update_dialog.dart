import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:nero_app/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';

class UpdateDialog extends StatelessWidget {
  final String storeUrl;
  final String platform;

  const UpdateDialog({
    Key? key,
    required this.storeUrl,
    required this.platform,
  }) : super(key: key);

  void _launchURL() async {
    Uri uri = Uri.parse(storeUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      print('URL을 열 수 없습니다: $storeUrl');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: Color(0xffD8D8D8).withOpacity(0.3),
        contentPadding: EdgeInsets.zero,
        content: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 40, left: 16, right: 16, bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "업데이트 필요",
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "새로운 버전이 출시되었습니다.",
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: Color(0xffD9D9D9),
                          ),
                        ),
                        Text(
                          "업데이트를 진행해주세요.",
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: Color(0xffD9D9D9),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: _launchURL,
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: AppColors.dialogTextFieldButtonColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                      child: Text(
                        platform == 'android'
                            ? 'PlayStore로 이동'
                            : 'AppStore로 이동',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Color(0xffD0EE17),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // 닫기 아이콘
            Positioned(
              top: 16,
              right: 16,
              child: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
