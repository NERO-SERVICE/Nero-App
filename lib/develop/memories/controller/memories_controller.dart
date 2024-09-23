import 'package:get/get.dart';

import '../model/memories.dart';
import '../repository/memories_repository.dart';

class MemoriesController extends GetxController {
  final MemoriesRepository _repository = MemoriesRepository();
  final Rx<Memories> memories = Memories.empty().obs;
  final RxList<Memories> memoriesList = <Memories>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadMemories();
  }

  Future<void> sendMemories(List<String> items) async {
    try {
      await _repository.sendMemories(items);
      // 서버로부터 새로운 데이터를 받아 업데이트
      await loadMemories();
    } catch (e) {
      print('챙길거리 controller 에러: $e');
    }
  }

  Future<void> loadMemories() async {
    List<Memories>? loadedMemories = await _repository.fetchMemories();
    if (loadedMemories != null) {
      memoriesList.value = loadedMemories;
      print('Loaded memories: ${memoriesList.length} items');
    } else {
      print('No memories loaded');
    }
  }

  // 수정된 부분: 반환 타입을 Future<void>로 변경하고 async 추가
  Future<void> addItem(String newItem) async {
    if (memoriesList.isNotEmpty) {
      final updatedItems = List<String>.from(memoriesList[0].items ?? []);
      updatedItems.add(newItem);

      // 서버에 업데이트된 리스트 전송
      await sendMemories(updatedItems);
    }
  }

  // 수정된 부분: 반환 타입을 Future<void>로 변경하고 async 추가
  Future<void> removeItemsAtIndices(List<int> indicesToRemove) async {
    if (memoriesList.isNotEmpty) {
      final updatedItems = List<String>.from(memoriesList[0].items ?? []);
      // 인덱스가 큰 순서대로 제거
      indicesToRemove.sort((a, b) => b.compareTo(a));
      for (int index in indicesToRemove) {
        if (index >= 0 && index < updatedItems.length) {
          updatedItems.removeAt(index);
        }
      }

      // 서버에 업데이트된 리스트 전송
      await sendMemories(updatedItems);
    }
  }
}
