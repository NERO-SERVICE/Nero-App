import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:nero_app/develop/dio_service.dart';
import 'package:nero_app/develop/health/model/health.dart';
import 'package:nero_app/develop/health/model/video_data.dart';

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

  // 동영상 데이터 가져오기
  Future<List<VideoData>> fetchVideoData({int pageNo = 1, int numOfRows = 100}) async {
    final String apiUrl = dotenv.env['HEALTH_OPEN_API_VIDEO'] ?? '';
    final String serviceKey = dotenv.env['HEALTH_OPEN_API_SECRET_KEY'] ?? '';

    try {
      final response = await _dioService.externalGet(
        apiUrl,
        params: {
          'serviceKey': serviceKey,
          'pageNo': pageNo.toString(),
          'numOfRows': numOfRows.toString(),
          'resultType': 'JSON',
        },
        requireToken: false,
      );

      if (response.statusCode == 200) {
        var data = response.data;

        if (data is String) {
          try {
            data = jsonDecode(data);
          } catch (e) {
            // JSON 파싱 실패 시 XML인지 확인
            if (data.startsWith('<')) {
              // XML 파싱 및 오류 처리
              print('Received XML error response');
              throw Exception('API Error: Invalid response format or service key');
            } else {
              throw Exception('Failed to parse response data: $e');
            }
          }
        }

        if (data is Map<String, dynamic>) {
          if (data['response']['header']['resultCode'] == '00') {
            final body = data['response']['body'];
            List<dynamic> items = body['items']['item'];

            List<VideoData> videos = items.map((item) {
              return VideoData.fromJson(item);
            }).toList();

            return videos;
          } else {
            throw Exception("API Error: ${data['response']['header']['resultMsg']}");
          }
        } else {
          throw Exception("Failed to parse response data");
        }
      } else {
        throw Exception("Failed to fetch video data: ${response.statusCode}");
      }
    } catch (e) {
      print('Failed to fetch video data: $e');
      throw e;
    }
  }
}
