import 'package:get/get.dart';
import 'package:nero_app/drf/calendar/model/drf_fastlog.dart';
import 'package:nero_app/drf/dio_service.dart';

class DrfFastlogController extends GetxController {
  var fastlogs = <DrfFastlog>[].obs;
  var isLoading = false.obs;
  var selectedDate = DateTime.now().obs;

  final DioService _dioService = DioService();

  @override
  void onInit() {
    super.onInit();
    fetchFastlogs(selectedDate.value);
  }

  void setSelectedDate(DateTime date) {
    selectedDate.value = date;
    fetchFastlogs(date);
  }

  Future<void> fetchFastlogs(DateTime date) async {
    isLoading.value = true;

    try {
      final response = await _dioService.get('/fastlogs/', params: {
        'year': date.year.toString(),
        'month': date.month.toString().padLeft(2, '0'),
        'day': date.day.toString().padLeft(2, '0'),
      });

      fastlogs.assignAll((response.data as List)
          .map((e) => DrfFastlog.fromJson(e))
          .toList());
    } catch (e) {
      print('Failed to load fast logs: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitFastlog(String content) async {
    isLoading.value = true;

    try {
      // 선택한 날짜를 "YYYY-MM-DD" 형식으로 변환하여 서버에 전송
      String formattedDate = selectedDate.value.toIso8601String().substring(0, 10);

      await _dioService.post('/fastlogs/', data: {
        'content': content,
        'date': formattedDate,
      });

      await fetchFastlogs(selectedDate.value);
    } catch (e) {
      print('Failed to submit fast log: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
