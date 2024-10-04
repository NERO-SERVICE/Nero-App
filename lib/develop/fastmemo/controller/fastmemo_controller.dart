import 'package:get/get.dart';
import '../model/fastmemo.dart';
import '../repository/fastmemo_repository.dart';

class FastmemoController extends GetxController {
  final FastmemoRepository repository;
  FastmemoController({required this.repository});

  var fastmemo = <Fastmemo>[].obs;
  var isLoading = false.obs;
  var selectedDate = DateTime.now().obs;
  var memoDates = <DateTime>{}.obs;
  var loadedYears = <int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMemoDates(DateTime.now().year);
    fetchFastmemo(DateTime.now());
  }

  void setSelectedDate(DateTime date) {
    selectedDate.value = date;
    fetchFastmemo(date);
    if (!loadedYears.contains(date.year)) {
      fetchMemoDates(date.year);
    }
  }

  Future<void> fetchFastmemo(DateTime date) async {
    isLoading.value = true;
    try {
      var fetchedMemos = await repository.getFastmemo(date);
      fastmemo.assignAll(fetchedMemos);
      if (fetchedMemos.isNotEmpty) {
        memoDates.add(DateTime(date.year, date.month, date.day));
      } else {
        memoDates.remove(DateTime(date.year, date.month, date.day));
      }
    } catch (e) {
      print('Failed to load fast logs: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchMemoDates(int year) async {
    try {
      var fetchedDates = await repository.getMemoDates(year);
      memoDates.addAll(fetchedDates);
      loadedYears.add(year);
    } catch (e) {
      print('Failed to fetch memo dates: $e');
    }
  }

  Future<void> submitFastmemo(String content) async {
    isLoading.value = true;
    try {
      String formattedDate = selectedDate.value.toIso8601String().substring(0, 10);
      var newMemo = await repository.createFastmemo(content, formattedDate);
      fastmemo.add(newMemo);
      memoDates.add(DateTime(newMemo.date.year, newMemo.date.month, newMemo.date.day));
    } catch (e) {
      print('Failed to submit fast log: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateFastmemo(int id, String content) async {
    try {
      await repository.updateFastmemo(id, content);
      await fetchFastmemo(selectedDate.value);
    } catch (e) {
      print('Failed to update fast log: $e');
    }
  }

  Future<void> deleteFastmemo(int id) async {
    try {
      await repository.deleteFastmemo(id);
      await fetchFastmemo(selectedDate.value);
    } catch (e) {
      print('Failed to delete fast log: $e');
    }
  }

  Future<void> bulkUpdateIsChecked(bool isChecked, List<int> ids) async {
    try {
      await repository.bulkUpdateIsChecked(isChecked, ids);
      await fetchFastmemo(selectedDate.value);
      await fetchMemoDates(selectedDate.value.year);
    } catch (e) {
      print('Failed to bulk update is_checked: $e');
    }
  }

  Future<void> bulkDeleteFastmemo(List<int> ids) async {
    try {
      await repository.bulkDeleteFastmemo(ids);
      await fetchFastmemo(selectedDate.value);
      await fetchMemoDates(selectedDate.value.year);
    } catch (e) {
      print('Failed to bulk delete fast logs: $e');
    }
  }
}
