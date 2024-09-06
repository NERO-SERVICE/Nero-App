import 'package:get/get.dart';
import 'package:nero_app/drf/mypage/model/drf_montly_check.dart';
import 'package:nero_app/drf/mypage/repository/drf_montly_check_repository.dart';

class DrfMonthlyCheckController extends GetxController {
  final DrfMonthlyCheckRepository _monthlyCheckRepository = DrfMonthlyCheckRepository();
  var selectedType = 'all'.obs;

  // Cache for storing monthly data
  Map<String, DrfMonthlyCheck> monthlyCheckCache = {};

  // 현재 보려는 달의 데이터를 가져옴
  void fetchMonthlyChecks(int year, int month) async {
    final currentMonthKey = '$year-$month';

    // 캐시에서 먼저 데이터 확인
    if (monthlyCheckCache.containsKey(currentMonthKey)) {
      print('Data loaded from cache for $currentMonthKey');
      return;
    }

    try {
      print('Fetching monthly checks for year: $year, month: $month, type: ${selectedType.value}');

      var fetchedMonthlyCheck = await _monthlyCheckRepository.getMonthlyCheck(year, month, selectedType.value);

      if (fetchedMonthlyCheck != null) {
        monthlyCheckCache[currentMonthKey] = fetchedMonthlyCheck;
        print('Fetched and cached monthly check data for $currentMonthKey');
      } else {
        print('No data fetched for this month.');
      }
    } catch (e) {
      print('Failed to fetch monthly checks: $e');
    }
  }

  // 현재 달, 이전 달, 다음 달 데이터를 미리 서버에서 가져오는 함수
  void preloadMonthlyData(int year, int month) {
    // 현재 달, 이전 달, 다음 달 데이터 요청
    fetchMonthlyChecks(year, month);

    if (month > 1) {
      fetchMonthlyChecks(year, month - 1); // 이전 달
    } else {
      fetchMonthlyChecks(year - 1, 12); // 1월이면 이전 달은 전년도 12월
    }

    if (month < 12) {
      fetchMonthlyChecks(year, month + 1); // 다음 달
    } else {
      fetchMonthlyChecks(year + 1, 1); // 12월이면 다음 달은 다음년도 1월
    }
  }

  // Set the selected type and print the change
  void setSelectedType(String type) {
    selectedType.value = type;
    print('Selected type updated: $type');
  }
}
