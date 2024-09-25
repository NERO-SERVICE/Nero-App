import 'package:get/get.dart';

import '../../dio_service.dart';
import '../model/fastmemo.dart';

class FastmemoRepository extends GetxController {
  var fastmemo = <Fastmemo>[].obs;
  var isLoading = false.obs;
  var selectedDate = DateTime.now().obs;
  var selectedIds = <int>[].obs;
  var memoDates = <DateTime>{}.obs;
  var loadedYears = <int>{}.obs;

  final DioService _dioService = DioService();

  @override
  void onInit() {
    super.onInit();
    fetchFastmemo(selectedDate.value);
    fetchMemoDates(selectedDate.value.year);
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
      final response = await _dioService.get('/fastlogs/', params: {
        'year': date.year.toString(),
        'month': date.month.toString().padLeft(2, '0'),
        'day': date.day.toString().padLeft(2, '0'),
      });
      print('Fastmemo Response: ${response.data}');
      var fetchedMemos =
          (response.data as List).map((e) => Fastmemo.fromJson(e)).toList();
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

      var fetchedMemos =
          (response.data as List).map((e) => Fastmemo.fromJson(e)).toList();
      fastmemo.assignAll(fetchedMemos);

      // 메모가 있는 날짜 업데이트
      if (fetchedMemos.isNotEmpty) {
        memoDates.add(DateTime(date.year, date.month, date.day));
      } else {
        memoDates.remove(DateTime(date.year, date.month, date.day));
      }
    } catch (e) {
      print('Failed to load unchecked fast logs: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchMemoDates(int year) async {
    if (loadedYears.contains(year)) {
      return;
    }

    try {
      final response = await _dioService.get('/fastlogs/dates/', params: {
        'year': year.toString(),
      });
      List<dynamic> dates = response.data;
      Set<DateTime> fetchedDates =
          dates.map((dateStr) => DateTime.parse(dateStr)).toSet();
      memoDates.addAll(fetchedDates);
      loadedYears.add(year);
    } catch (e) {
      print('Failed to fetch memo dates: $e');
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
      memoDates.add(
          DateTime(newMemo.date.year, newMemo.date.month, newMemo.date.day));
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
      await fetchMemoDates(selectedDate.value.year); // 체크 상태 변경 후 날짜 목록을 갱신합니다.
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
      await fetchMemoDates(selectedDate.value.year); // 삭제 후 날짜 목록을 갱신합니다.
    } catch (e) {
      print('Failed to bulk delete fast logs: $e');
    }
  }
}
