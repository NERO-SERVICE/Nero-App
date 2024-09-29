import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nero_app/develop/common/components/custom_detail_app_bar.dart';
import 'package:nero_app/develop/home/magazine/page/magazine_list_page.dart';
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

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = packageInfo.version; // 앱 버전 정보
    });
  }

  @override
  Widget build(BuildContext context) {
    final AuthenticationController authController =
        Get.find<AuthenticationController>();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomDetailAppBar(title: '설정'),
      body: Column(
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
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MagazineListPage()),
                );
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
    );
  }
}
