import 'package:nero_app/develop/dio_service.dart';

class MemoriesRepository {
  final DioService _dio = DioService();

  Future<void> sendMemories(List<String> items) async {
    try {
      final response = await _dio.post(
        '/accounts/memories/',
        data: {
          'items': items,
        },
      );
      if (response.statusCode == 201) {
        print('챙길거리를 성공적으로 생성했습니다');
      } else {
        print('챙길거리 생성에 실패했습니다. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('챙길거리에서 오류가 나왔습니다: $e');
    }
  }
}
