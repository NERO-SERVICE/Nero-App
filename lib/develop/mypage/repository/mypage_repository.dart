import 'package:get/get.dart';
import 'package:nero_app/develop/todaylog/recall/model/response_subtype.dart';

import '../../dio_service.dart';
import '../model/menstruation_cycle.dart';
import '../model/monthly_check.dart';

class MypageRepository {
  final DioService _dio = Get.find<DioService>();

  Future<Map<int, MonthlyCheck>?> getYearlyCheck(int year, String type) async {
    try {
      final String url = '/mypage/yearly-log/$year/?type=$type';
      final response = await _dio.get(url);

      Map<int, MonthlyCheck> yearlyData = {};
      Map<String, dynamic> data = response.data;

      data.forEach((monthStr, monthData) {
        int month = int.parse(monthStr);
        MonthlyCheck monthlyCheck = MonthlyCheck.fromJson(monthData);
        yearlyData[month] = monthlyCheck;
      });

      return yearlyData;
    } catch (e) {
      return null;
    }
  }


  Future<List<ResponseSubtype>> getSurveyResponsesByDate(DateTime date) async {
    try {
      final response = await _dio.get('/todaylogs/response/before/', params: {
        'type': 'survey',
        'year': date.year.toString(),
        'month': date.month.toString().padLeft(2, '0'),
        'day': date.day.toString().padLeft(2, '0'),
      });

      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        final subtypesJson = response.data['subtypes'] as List<dynamic>?;

        if (subtypesJson != null) {
          for (var subtypeJson in subtypesJson) {
            print('Subtype Name: ${subtypeJson['subtype_name']}');
            for (var questionJson in subtypeJson['questions']) {
              print('  Question: ${questionJson['question_text']}');
              if (questionJson['selected_answer'] != null) {
                print(
                    '    Answer: ${questionJson['selected_answer']['answer_text']}');
              } else {
                print('    Answer: 선택된 답변이 없습니다.');
              }
            }
          }

          return subtypesJson
              .map((json) =>
                  ResponseSubtype.fromJson(json as Map<String, dynamic>))
              .toList();
        } else {
          print('subtypes 키가 존재하지 않습니다.');
          return [];
        }
      } else {
        print('Unexpected response format');
        return [];
      }
    } catch (e) {
      print('Failed to load survey responses: $e');
      return [];
    }
  }


  Future<List<ResponseSubtype>> getSideEffectResponsesByDate(
      DateTime date) async {
    try {
      final response = await _dio.get('/todaylogs/response/before/', params: {
        'type': 'side_effect',
        'year': date.year.toString(),
        'month': date.month.toString().padLeft(2, '0'),
        'day': date.day.toString().padLeft(2, '0'),
      });

      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        final subtypesJson = response.data['subtypes'] as List<dynamic>?;

        if (subtypesJson != null) {
          for (var subtypeJson in subtypesJson) {
            print('Subtype Name: ${subtypeJson['subtype_name']}');
            for (var questionJson in subtypeJson['questions']) {
              print('  Question: ${questionJson['question_text']}');
              if (questionJson['selected_answer'] != null) {
                print(
                    '    Answer: ${questionJson['selected_answer']['answer_text']}');
              } else {
                print('    Answer: 선택된 답변이 없습니다.');
              }
            }
          }

          return subtypesJson
              .map((json) =>
                  ResponseSubtype.fromJson(json as Map<String, dynamic>))
              .toList();
        } else {
          print('subtypes 키가 존재하지 않습니다.');
          return [];
        }
      } else {
        print('Unexpected response format');
        return [];
      }
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


  Future<Set<DateTime>> getSurveyRecordedDates(int year) async {
    try {
      final String url = '/todaylogs/response/dates/?year=$year&type=survey';
      final response = await _dio.get(url);
      List<dynamic> dates = response.data;
      return dates.map((dateStr) => DateTime.parse(dateStr)).toSet();
    } catch (e) {
      print('Failed to fetch survey recorded dates: $e');
      return {};
    }
  }

  // Fetch recorded dates for side effects
  Future<Set<DateTime>> getSideEffectRecordedDates(int year) async {
    try {
      final String url =
          '/todaylogs/response/dates/?year=$year&type=side_effect';
      final response = await _dio.get(url);
      List<dynamic> dates = response.data;
      return dates.map((dateStr) => DateTime.parse(dateStr)).toSet();
    } catch (e) {
      print('Failed to fetch side effect recorded dates: $e');
      return {};
    }
  }


  Future<Set<DateTime>> getSelfRecordRecordedDates(int year) async {
    try {
      final String url = '/todaylogs/self_record/dates/?year=$year';
      final response = await _dio.get(url);
      List<dynamic> dates = response.data;
      return dates.map((dateStr) => DateTime.parse(dateStr)).toSet();
    } catch (e) {
      print('Failed to fetch self-record recorded dates: $e');
      return {};
    }
  }
}
