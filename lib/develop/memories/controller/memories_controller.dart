import 'package:get/get.dart';
import 'package:nero_app/develop/memories/repository/memories_repository.dart';

class MemoriesController extends GetxController {
  final MemoriesRepository _repository = MemoriesRepository();

  Future<void> sendMemories(List<String> items) async {
    try {
      await _repository.sendMemories(items);
    } catch (e) {
      print('챙길거리 controller 에러: $e');
    }
  }
}
