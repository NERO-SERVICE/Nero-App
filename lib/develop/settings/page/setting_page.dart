import 'dart:ui';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nero_app/develop/common/components/custom_detail_app_bar.dart';
import 'package:nero_app/develop/settings/page/setting_policy_webview.dart';
import 'package:nero_app/develop/settings/page/setting_service_webview.dart';
import 'package:nero_app/develop/user/controller/authentication_controller.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  String _appVersion = '...';
  late AuthenticationController authController; // authController를 클래스 필드로 선언
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
    authController = Get.find<AuthenticationController>(); // authController 인스턴스 할당
  }

  Future<void> _loadAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = packageInfo.version; // 앱 버전 정보
    });
  }

  Future<void> _withdrawDialog() async {
    return showDialog(
      context: context,
      barrierDismissible: true, // 다이얼로그 외부 영역을 터치하면 닫히도록 설정
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // 블러 효과 적용
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor: Color(0xffD8D8D8).withOpacity(0.3),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 22),
                    const Text(
                      "회원 탈퇴 하시겠습니까?",
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 40),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 44),
                      child: Text(
                        "탈퇴 버튼을 선택할 시\n계정은 삭제되며\n복구되지 않습니다",
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color(0xffD9D9D9),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 38),
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                  await authController.deleteAccount();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xffFF5A5A).withOpacity(0.3),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 14),
                                ),
                                child: const Text(
                                  "탈퇴",
                                  style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: Color(0xffD9D9D9),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xffD8D8D8).withOpacity(0.3),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 14),
                                ),
                                child: const Text(
                                  "취소",
                                  style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Color(0xffFFFFFF),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    analytics.logScreenView(
      screenName: 'SettingPage',
      screenClass: 'SettingPage',
    );
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomDetailAppBar(title: '설정'),
      body: SingleChildScrollView( // 스크롤 가능하도록 수정
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: kToolbarHeight + 56),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingPolicyWebview()),
                  );
                },
                child: Text(
                  '개인정보 처리방침',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Color(0xffD9D9D9),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingServiceWebview()),
                  );
                },
                child: Text(
                  '서비스 이용약관',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Color(0xffD9D9D9),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
              child: GestureDetector(
                onTap: () async {
                  await authController.logout();
                },
                child: Text(
                  '로그아웃',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Color(0xffD9D9D9),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
              child: GestureDetector(
                onTap: () async {
                  await _withdrawDialog();
                },
                child: Text(
                  '회원탈퇴',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Color(0xffD9D9D9),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '앱 버전',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Color(0xffD9D9D9),
                    ),
                  ),
                  Text(
                    _appVersion,
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Color(0xff3C3C3C),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
