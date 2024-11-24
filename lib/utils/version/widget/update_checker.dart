import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nero_app/utils/version/models/app_version.dart';
import 'package:nero_app/utils/version/version_service.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'update_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateChecker extends StatefulWidget {
  final Widget child;

  const UpdateChecker({Key? key, required this.child}) : super(key: key);

  @override
  _UpdateCheckerState createState() => _UpdateCheckerState();
}

class _UpdateCheckerState extends State<UpdateChecker> {
  late VersionService _versionService;

  @override
  void initState() {
    super.initState();
    _versionService = Get.find<VersionService>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkForUpdate();
    });
  }

  Future<void> _checkForUpdate() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int lastCheck = prefs.getInt('lastUpdateCheck') ?? 0;
      int currentTime = DateTime.now().millisecondsSinceEpoch;
      // 하루 동안은 업데이트 체크를 하지 않음 (86400000 밀리초 = 1일)
      if (currentTime - lastCheck < 86400000) {
        print('최근에 업데이트를 체크했습니다.');
        return;
      }

      // 현재 앱 버전 가져오기
      String currentVersion = await getCurrentVersion();
      print('현재 버전: $currentVersion');

      // 플랫폼 정보 가져오기
      String platform;
      if (GetPlatform.isAndroid) {
        platform = 'android';
      } else if (GetPlatform.isIOS) {
        platform = 'ios';
      } else {
        print('지원하지 않는 플랫폼');
        return;
      }

      print('플랫폼: $platform에서 업데이트 확인 중');

      // 서버로부터 최신 버전 정보 가져오기
      AppVersion? latestVersion = await _versionService.fetchLatestVersion(platform);

      if (latestVersion == null) {
        print('최신 버전 정보를 가져올 수 없습니다.');
        return;
      }

      print('최신 버전: ${latestVersion.version}');

      // 버전 비교
      if (_isVersionOlder(currentVersion, latestVersion.version)) {
        print('새로운 버전이 있습니다.');
        _showUpdateDialog(latestVersion.storeUrl, latestVersion.platform);
      } else {
        print('현재 버전이 최신입니다.');
      }

      // 업데이트 체크 후 마지막 체크 시간 저장
      prefs.setInt('lastUpdateCheck', currentTime);
    } catch (e) {
      print('업데이트 확인 중 오류 발생: $e');
    }
  }

  bool _isVersionOlder(String current, String latest) {
    List<int> currentParts = current.split('.').map(int.parse).toList();
    List<int> latestParts = latest.split('.').map(int.parse).toList();

    for (int i = 0; i < latestParts.length; i++) {
      if (i >= currentParts.length) return true;
      if (latestParts[i] > currentParts[i]) return true;
      if (latestParts[i] < currentParts[i]) return false;
    }
    return false;
  }

  Future<String> getCurrentVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  void _showUpdateDialog(String storeUrl, String platform) {
    Get.dialog(
      UpdateDialog(
        storeUrl: storeUrl,
        platform: platform,
      ),
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
