import 'package:get/get.dart';
import 'package:nero_app/develop/dio_service.dart';
import 'package:nero_app/develop/memories/model/memories.dart';

class MemoriesRepository {
  final DioService _dio = Get.find<DioService>();

  Future<List<Memories>?> fetchMemories() async {
    try {
      final response = await _dio.get('/accounts/memories/');

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        List<Memories> memoriesList = data.map((memory) => Memories.fromJson(memory)).toList();
        return memoriesList;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }


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
