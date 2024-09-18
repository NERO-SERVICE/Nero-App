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
    } catch (e) {
      print('챙길거리 controller 에러: $e');
    }
  }

  // 서버에서 Memories 리스트를 불러오는 함수
  Future<void> loadMemories() async {
    List<Memories>? loadedMemories = await _repository.fetchMemories();
    if (loadedMemories != null) {
      memoriesList.value = loadedMemories;
      print('Loaded memories: ${memoriesList.length} items');
    } else {
      print('No memories loaded');
    }
  }

  // 아이템 추가 함수 (첫번째 메모리 아이템에 추가)
  void addItem(String newItem) {
    if (memoriesList.isNotEmpty) {
      final updatedItems = List<String>.from(memoriesList[0].items ?? []);
      updatedItems.add(newItem);

      // 서버에 업데이트된 리스트 전송
      _repository.sendMemories(updatedItems);

      // UI 업데이트
      memoriesList[0] = memoriesList[0].copyWith(items: updatedItems);
    }
  }

  // 특정 인덱스의 아이템 삭제 (첫번째 메모리에서 삭제)
  void removeItemAt(int index) {
    if (memoriesList.isNotEmpty && index >= 0 && index < memoriesList[0].items!.length) {
      final updatedItems = List<String>.from(memoriesList[0].items ?? []);
      updatedItems.removeAt(index);

      // 서버에 업데이트된 리스트 전송
      _repository.sendMemories(updatedItems);

      // UI 업데이트
      memoriesList[0] = memoriesList[0].copyWith(items: updatedItems);
    }
  }

  // 여러 아이템 삭제
  void removeItems(List<String> itemsToRemove) {
    final updatedItems = List<String>.from(memories.value.items ?? []);
    updatedItems.removeWhere((item) => itemsToRemove.contains(item));

    // 서버에 업데이트된 items를 보내는 로직
    sendMemories(updatedItems);

    // UI 업데이트
    memories.update((val) {
      val?.items = updatedItems;
    });
  }
}
