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

  // Survey 응답을 가져오는 메서드
  Future<List<dynamic>> getSurveyResponsesByDate(DateTime date) async {
    try {
      final String url = '/todaylogs/survey/date/?year=${date.year}&month=${date.month}&day=${date.day}';
      print('Requesting survey data from URL: $url');

      final response = await _dio.get(url);

      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');

      return response.data; // 서버에서 받은 설문 응답 데이터
    } catch (e) {
      print('Failed to load survey responses: $e');
      return [];
    }
  }

  // Side Effect 응답을 가져오는 메서드
  Future<List<dynamic>> getSideEffectResponsesByDate(DateTime date) async {
    try {
      final String url = '/todaylogs/side_effect/date/?year=${date.year}&month=${date.month}&day=${date.day}';
      print('Requesting side effect data from URL: $url');

      final response = await _dio.get(url);

      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');

      return response.data; // 서버에서 받은 부작용 응답 데이터
    } catch (e) {
      print('Failed to load side effect responses: $e');
      return [];
    }
  }

  Future<List<dynamic>> getSelfRecordResponsesByDate(DateTime date) async {
    try {
      final String url = '/todaylogs/self_record/date/?year=${date.year}&month=${date.month}&day=${date.day}';
      final response = await _dio.get(url);
      print('SelfRecord Response data: ${response.data}');
      return response.data;
    } catch (e) {
      print('Failed to load self-record responses: $e');
      return [];
    }
  }
}
