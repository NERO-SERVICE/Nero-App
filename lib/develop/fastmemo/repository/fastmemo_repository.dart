import 'package:get/get.dart';

import '../../dio_service.dart';
import '../model/fastmemo.dart';

class FastmemoRepository extends GetxController {
  var fastmemo = <Fastmemo>[].obs;
  var isLoading = false.obs;
  var selectedDate = DateTime.now().obs;
  var selectedIds = <int>[].obs;

  final DioService _dioService = DioService();

  @override
  void onInit() {
    super.onInit();
    fetchFastmemo(selectedDate.value);
  }

  void setSelectedDate(DateTime date) {
    selectedDate.value = date;
    fetchFastmemo(date);
  }

  Future<void> fetchFastmemo(DateTime date) async {
    isLoading.value = true;

    try {
      final response = await _dioService.get('/fastlogs/', params: {
        'year': date.year.toString(),
        'month': date.month.toString().padLeft(2, '0'),
        'day': date.day.toString().padLeft(2, '0'),
      });
      print('Fastmemo Response: ${response.data}');
      fastmemo.assignAll(
          (response.data as List).map((e) => Fastmemo.fromJson(e)).toList());
    } catch (e) {
      print('Failed to load fast logs: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchUncheckedFastmemo(DateTime date) async {
    isLoading.value = true;

    try {
      final response = await _dioService.get('/fastlogs/unchecked/', params: {
        'year': date.year.toString(),
        'month': date.month.toString().padLeft(2, '0'),
        'day': date.day.toString().padLeft(2, '0'),
      });

      // 응답 데이터 출력
      print('Unchecked Fastmemo Response: ${response.data}');

      fastmemo.assignAll(
          (response.data as List).map((e) => Fastmemo.fromJson(e)).toList());
    } catch (e) {
      print('Failed to load fast logs: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitFastmemo(String content) async {
    isLoading.value = true;

    try {
      String formattedDate =
          selectedDate.value.toIso8601String().substring(0, 10);

      final response = await _dioService.post('/fastlogs/', data: {
        'content': content,
        'date': formattedDate,
      });

      final newMemo = Fastmemo.fromJson(response.data);
      fastmemo.add(newMemo);
    } catch (e) {
      print('Failed to submit fast log: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // 메모 수정하기
  Future<void> updateFastmemo(int id, String content) async {
    try {
      await _dioService.patch('/fastlogs/$id/', data: {'content': content});
      await fetchFastmemo(selectedDate.value);
    } catch (e) {
      print('Failed to update fast log: $e');
    }
  }

  // 메모 삭제하기
  Future<void> deleteFastmemo(int id) async {
    try {
      await _dioService.delete('/fastlogs/$id/');
      await fetchFastmemo(selectedDate.value);
    } catch (e) {
      print('Failed to delete fast log: $e');
    }
  }

  // 다수의 메모 체크 상태 변경
  Future<void> bulkUpdateIsChecked(bool isChecked, List<int> ids) async {
    try {
      await _dioService.post('/fastlogs/bulk/', data: {
        'ids': ids, // 선택한 ID 리스트
        'is_checked': isChecked,
      });
      await fetchFastmemo(selectedDate.value);
    } catch (e) {
      print('Failed to bulk update is_checked: $e');
    }
  }

  // 다수의 메모 삭제
  Future<void> bulkDeleteFastmemo(List<int> ids) async {
    try {
      await _dioService.delete('/fastlogs/bulk/', data: {
        'ids': ids, // 선택한 ID 리스트
      });
      await fetchFastmemo(selectedDate.value);
    } catch (e) {
      print('Failed to bulk delete fast logs: $e');
    }
  }
}
