import 'package:get/get.dart';
import 'package:nero_app/develop/dio_service.dart';
import 'package:dio/dio.dart' as origindio;
import 'package:nero_app/develop/health/model/health.dart';
import 'package:nero_app/develop/health/model/health_user_info.dart';
import 'package:nero_app/develop/health/model/paginated_video_data.dart';
import 'package:nero_app/develop/health/model/predicted_steps_data.dart';

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

  Future<List<StepCount>> fetchStepsFromBackendWithinDateRange(DateTime startDate, DateTime endDate) async {
    try {
      final response = await _dioService.get(
        '/health/steps/',
        params: {
          'start_date': startDate.toIso8601String().split('T')[0], // YYYY-MM-DD 형식
          'end_date': endDate.toIso8601String().split('T')[0],
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> responseData = response.data;

        List<StepCount> steps = responseData.map((json) => StepCount.fromJson(json)).toList();

        return steps;
      } else {
        throw Exception("Failed to fetch steps data");
      }
    } catch (e) {
      print('Failed to fetch steps data within date range: $e');
      throw e;
    }
  }

  // HealthUserInfo 가져오기
  Future<HealthUserInfo?> fetchHealthUserInfo() async {
    try {
      final response = await _dioService.get(
        '/health/health_info/',
      );

      if (response.statusCode == 200) {
        List<dynamic> responseData = response.data;
        if (responseData.isNotEmpty) {
          return HealthUserInfo.fromJson(responseData[0]);
        } else {
          return null;
        }
      } else {
        throw Exception("Failed to fetch health user info");
      }
    } catch (e) {
      print('Failed to fetch health user info: $e');
      throw e;
    }
  }

  // HealthUserInfo 생성 또는 업데이트
  Future<HealthUserInfo> createOrUpdateHealthUserInfo(
      HealthUserInfo info) async {
    try {
      final existingInfo = await fetchHealthUserInfo();
      origindio.Response response;

      if (existingInfo != null) {
        // 업데이트
        response = await _dioService.put(
          '/health/health_info/${existingInfo.id}/',
          data: info.toJson(),
        );
      } else {
        // 생성
        response = await _dioService.post(
          '/health/health_info/',
          data: info.toJson(),
        );
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        return HealthUserInfo.fromJson(response.data);
      } else {
        throw Exception("Failed to create or update health user info");
      }
    } catch (e) {
      print('Failed to create or update health user info: $e');
      throw e;
    }
  }

  // 추천 동영상 데이터를 서버에서 가져오는 메서드 (페이지네이션)
  Future<PaginatedVideoData> fetchRecommendedVideos(String sportsStep, {int page = 1, int pageSize = 10}) async {
    try {
      final response = await _dioService.get(
        '/health/videos/recommendations/',
        params: {
          'sports_step': sportsStep,
          'page': page.toString(),
          'page_size': pageSize.toString(),
        },
      );

      if (response.statusCode == 200) {
        return PaginatedVideoData.fromJson(response.data);
      } else {
        throw Exception(
            "Failed to fetch recommended videos: ${response.statusCode}");
      }
    } catch (e) {
      print('Failed to fetch recommended videos: $e');
      throw e;
    }
  }

  // 다음 주 예측 걸음 수를 가져오기 위한 메서드
  Future<PredictedStepsData> fetchPredictedSteps() async {
    try {
      final response = await _dioService.get('/health/steps/predict/');

      if (response.statusCode == 200) {
        return PredictedStepsData.fromJson(response.data);
      } else {
        return PredictedStepsData(error: "Failed to fetch predicted steps. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print('Failed to fetch predicted steps: $e');
      return PredictedStepsData(error: "Failed to fetch predicted steps: $e");
    }
  }
}
