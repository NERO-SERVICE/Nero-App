import '../../dio_service.dart';
import '../model/menstruation_cycle.dart';
import '../model/monthly_check.dart';

class MypageRepository {
  final DioService _dio = DioService();

  Future<Map<int, MonthlyCheck>?> getYearlyCheck(int year, String type) async {
    try {
      final String url = '/mypage/yearly-log/$year/?type=$type';
      print('Requesting yearly data from URL: $url');

      final response = await _dio.get(url);

      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');

      Map<int, MonthlyCheck> yearlyData = {};

      // 서버에서 반환한 데이터 파싱
      Map<String, dynamic> data = response.data;

      data.forEach((monthStr, monthData) {
        int month = int.parse(monthStr);
        MonthlyCheck monthlyCheck = MonthlyCheck.fromJson(monthData);
        yearlyData[month] = monthlyCheck;
      });

      return yearlyData;
    } catch (e) {
      print('Failed to load yearly check: $e');
      return null;
    }
  }

  Future<List<dynamic>> getSurveyResponsesByDate(DateTime date) async {
    try {
      final String url =
          '/todaylogs/survey/date/?year=${date.year}&month=${date.month}&day=${date.day}';
      print('Requesting survey data from URL: $url');

      final response = await _dio.get(url);

      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');

      return response.data;
    } catch (e) {
      print('Failed to load survey responses: $e');
      return [];
    }
  }

  Future<List<dynamic>> getSideEffectResponsesByDate(DateTime date) async {
    try {
      final String url =
          '/todaylogs/side_effect/date/?year=${date.year}&month=${date.month}&day=${date.day}';
      print('Requesting side effect data from URL: $url');

      final response = await _dio.get(url);

      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');

      return response.data;
    } catch (e) {
      print('Failed to load side effect responses: $e');
      return [];
    }
  }

  Future<List<dynamic>> getSelfRecordResponsesByDate(DateTime date) async {
    try {
      final String url =
          '/todaylogs/self_record/date/?year=${date.year}&month=${date.month}&day=${date.day}';
      final response = await _dio.get(url);
      print('SelfRecord Response data: ${response.data}');
      return response.data;
    } catch (e) {
      print('Failed to load self-record responses: $e');
      return [];
    }
  }

  Future<List<MenstruationCycle>> getMenstruationCycles(int year) async {
    try {
      final String url = '/menstruation/cycles/?year=$year';
      final response = await _dio.get(url);

      List<dynamic> data = response.data;
      return data.map((json) => MenstruationCycle.fromJson(json)).toList();
    } catch (e) {
      print('Failed to load menstruation cycles: $e');
      return [];
    }
  }

  Future<bool> createMenstruationCycle(MenstruationCycle cycle) async {
    try {
      final response = await _dio.post('/menstruation/', data: cycle.toJson());
      return response.statusCode == 201;
    } catch (e) {
      print('Failed to create menstruation cycle: $e');
      return false;
    }
  }
}
