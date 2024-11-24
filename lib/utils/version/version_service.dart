import 'package:get/get.dart';
import 'package:nero_app/develop/dio_service.dart';
import 'package:nero_app/utils/version/models/app_version.dart';

class VersionService extends GetxService {
  final DioService _dio = Get.find<DioService>();

  Future<AppVersion?> fetchLatestVersion(String platform) async {
    try {
      final String endpoint = '/appmanage/app-version/';
      final response = await _dio.get(
        endpoint,
        params: {'platform': platform},
        requireToken: false,
      );

      if (response.statusCode == 200) {
        return AppVersion.fromJson(response.data);
      } else {
        print('Failed to fetch version info: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching version info: $e');
      return null;
    }
  }
}