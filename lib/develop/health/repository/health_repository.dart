import 'package:get/get.dart';
import 'package:nero_app/develop/dio_service.dart';
import 'package:nero_app/develop/health/model/health.dart';

class HealthRepository {
  final DioService _dioService = Get.find<DioService>();

  // 백엔드로 걸음 수 데이터 전송
  Future<bool> sendStepsToBackend(int steps, DateTime date) async {
    try {
      final response = await _dioService.post(
        '/health/steps/', // baseUrl 이후의 상대 경로
        data: {
          'date': date.toIso8601String().split('T')[0], // YYYY-MM-DD 형식
          'steps': steps,
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return true;
      } else {
        print('Failed to send steps: ${response.data}');
        return false;
      }
    } catch (e) {
      print('Failed to send steps: $e');
      return false;
    }
  }

  // 백엔드에서 걸음 수 데이터 가져오기
  Future<List<StepCount>> fetchStepsFromBackend() async {
    try {
      final response = await _dioService.get(
        '/health/steps/',
      );

      if (response.statusCode == 200) {
        List<dynamic> responseData = response.data;

        List<StepCount> steps = responseData.map((json) => StepCount.fromJson(json)).toList();

        return steps;
      } else {
        throw Exception("Failed to fetch steps data");
      }
    } catch (e) {
      print('Failed to fetch steps data: $e');
      throw e;
    }
  }
}
