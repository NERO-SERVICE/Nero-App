import 'package:nero_app/drf/dio_service.dart';
import 'package:nero_app/drf/mypage/model/drf_montly_check.dart';

class DrfMonthlyCheckRepository {
  final DioService _dio = DioService();

  // Print request and response
  Future<DrfMonthlyCheck?> getMonthlyCheck(int year, int month, String type) async {
    try {
      final String url = '/mypage/yearly-log/$year/$month/?type=$type';
      print('Requesting data from URL: $url');

      final response = await _dio.get(url);

      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');

      return DrfMonthlyCheck.fromJson(response.data);
    } catch (e) {
      print('Failed to load monthly check: $e');
      return null;
    }
  }
}
