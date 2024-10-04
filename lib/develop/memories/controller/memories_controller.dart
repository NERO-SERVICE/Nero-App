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
      await loadMemories();
    } catch (e) {
      print('챙길거리 controller 에러: $e');
    }
  }


  Future<void> loadMemories() async {
    List<Memories>? loadedMemories = await _repository.fetchMemories();
    if (loadedMemories != null) {
      memoriesList.value = loadedMemories;
    } else {
      print('No memories loaded');
    }
  }


  Future<void> addItem(String newItem) async {
    if (memoriesList.isNotEmpty) {
      final updatedItems = List<String>.from(memoriesList[0].items ?? []);
      updatedItems.add(newItem);
      await sendMemories(updatedItems);
    }
  }


  Future<void> removeItemsAtIndices(List<int> indicesToRemove) async {
    if (memoriesList.isNotEmpty) {
      final updatedItems = List<String>.from(memoriesList[0].items ?? []);
      indicesToRemove.sort((a, b) => b.compareTo(a));

      for (int index in indicesToRemove) {
        if (index >= 0 && index < updatedItems.length) {
          updatedItems.removeAt(index);
        }
      }
      await sendMemories(updatedItems);
    }
  }
}
