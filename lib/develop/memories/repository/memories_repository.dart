import 'package:nero_app/develop/dio_service.dart';
import 'package:nero_app/develop/memories/model/memories.dart';

class MemoriesRepository {
  final DioService _dio = DioService();

  // 서버에서 Memories 리스트를 받아오는 함수
  Future<List<Memories>?> fetchMemories() async {
    try {
      final response = await _dio.get('/accounts/memories/');

      // 서버에서 받아온 데이터를 로그로 확인
      print('Memories response: ${response.data}');

      if (response.statusCode == 200) {
        // 리스트 형태로 받아서 처리
        List<dynamic> data = response.data;
        List<Memories> memoriesList = data.map((memory) => Memories.fromJson(memory)).toList();
        print('Memories parsed: $memoriesList');
        return memoriesList;
      } else {
        print('Failed to load memories. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching memories: $e');
      return null;
    }
  }

  // 서버로 items 리스트를 업데이트하는 함수 (POST 또는 PATCH)
  Future<void> sendMemories(List<String> items) async {
    try {
      final response = await _dio.post(
        '/accounts/memories/',
        data: {
          'items': items,
        },
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        print('Successfully updated memories: $items');
      } else {
        print('Failed to update memories. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating memories: $e');
    }
  }
}
