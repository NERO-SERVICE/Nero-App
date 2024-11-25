import 'dart:io';
import 'dart:ui';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nero_app/app_colors.dart';
import 'package:nero_app/develop/common/components/custom_detail_app_bar.dart';
import 'package:nero_app/develop/common/components/custom_snackbar.dart';
import 'package:nero_app/develop/settings/page/setting_policy_webview.dart';
import 'package:nero_app/develop/settings/page/setting_service_webview.dart';
import 'package:nero_app/develop/user/controller/authentication_controller.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> with WidgetsBindingObserver {
  String _appVersion = '...';
  late AuthenticationController authController; // authController를 클래스 필드로 선언
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Observer 등록
    _loadAppVersion();
    authController =
        Get.find<AuthenticationController>(); // authController 인스턴스 할당
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Observer 해제
    super.dispose();
  }

  // 앱의 라이프사이클 상태가 변경될 때 호출됨
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // 앱이 다시 포그라운드로 돌아왔을 때 UI를 업데이트
      setState(() {});
    }
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
                                  backgroundColor:
                                      Color(0xffFF5A5A).withOpacity(0.3),
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
                                  backgroundColor:
                                      Color(0xffD8D8D8).withOpacity(0.3),
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

  Future<void> _managePhotoPermission() async {
    Permission permission;
    if (Platform.isAndroid) {
      permission = Permission.storage;
    } else if (Platform.isIOS) {
      permission = Permission.photos;
    } else {
      CustomSnackbar.show(
        context: context,
        message: '이 플랫폼에서는 사진 권한을 지원하지 않습니다.',
        isSuccess: false,
      );
      return;
    }

    // 항상 권한 요청 시도
    PermissionStatus status = await permission.request();

    if (status.isGranted) {
      // 권한 허용된 상태
      await openAppSettings();
    } else if (status.isPermanentlyDenied) {
      // 영구적으로 거부된 경우, 설정으로 바로 이동
      await openAppSettings();
    } else {
      // 권한이 거부된 경우
      await openAppSettings();
    }
  }

  Future<PermissionStatus> _getCurrentPhotoPermissionStatus() async {
    if (Platform.isAndroid) {
      return await Permission.storage.status;
    } else if (Platform.isIOS) {
      return await Permission.photos.status;
    } else {
      return PermissionStatus.denied;
    }
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
      body: SingleChildScrollView(
        // 스크롤 가능하도록 수정
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
                    MaterialPageRoute(
                        builder: (context) => SettingPolicyWebview()),
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
                    MaterialPageRoute(
                        builder: (context) => SettingServiceWebview()),
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
              padding: const EdgeInsets.only(
                  left: 32, right: 16, top: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '사진 권한 설정',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Color(0xffD9D9D9),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.settings,
                    ),
                    color: Color(0xffD9D9D9),
                    onPressed: () async {
                      await _managePhotoPermission();
                      setState(() {}); // 상태 업데이트
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
              child: FutureBuilder<PermissionStatus>(
                future: _getCurrentPhotoPermissionStatus(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '현재 사진 권한 상태',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Color(0xffD9D9D9),
                          ),
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '현재 사진 권한 상태',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Color(0xffD9D9D9),
                          ),
                        ),
                        Icon(Icons.error, color: Colors.red, size: 16),
                      ],
                    );
                  } else {
                    PermissionStatus status = snapshot.data!;
                    String statusText;
                    Color statusColor;
                    if (status.isGranted) {
                      statusText = '허용됨';
                      statusColor = Colors.green;
                    } else {
                      statusText = '거부됨';
                      statusColor = Colors.red;
                    }

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '현재 사진 권한 상태',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Color(0xffD9D9D9),
                          ),
                        ),
                        Text(
                          statusText,
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: statusColor,
                          ),
                        ),
                      ],
                    );
                  }
                },
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
                      color: AppColors.inactiveTextColor,
                    ),
                  ),
                ],
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
                    color: AppColors.inactiveTextColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
