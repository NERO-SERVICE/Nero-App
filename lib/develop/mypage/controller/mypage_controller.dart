import 'package:get/get.dart';
import 'package:nero_app/develop/mypage/repository/mypage_repository.dart';

import '../../todaylog/recall/model/self_record.dart';
import '../../todaylog/recall/model/side_effect.dart';
import '../../todaylog/recall/model/survey.dart';
import '../model/menstruation_cycle.dart';
import '../model/monthly_check.dart';

class MypageController extends GetxController {
  final MypageRepository _mypageRepository = MypageRepository();
  var selectedType = 'all'.obs;

  var isLoading = true.obs;
  var surveyResponses = <Survey>[].obs;
  var sideEffectResponses = <SideEffect>[].obs;
  var selfRecordResponses = <SelfRecord>[].obs;
  var menstruationCycles = <MenstruationCycle>[].obs;

  Map<String, MonthlyCheck> monthlyCheckCache = {};

  void fetchYearlyChecks(int year) async {
    try {
      print('Fetching yearly checks for year: $year, type: ${selectedType.value}');

      var fetchedYearlyCheck = await _mypageRepository.getYearlyCheck(year, selectedType.value);

      if (fetchedYearlyCheck != null) {
        // 캐시에 월별 데이터 저장
        fetchedYearlyCheck.forEach((month, data) {
          final currentMonthKey = '$year-$month';
          monthlyCheckCache[currentMonthKey] = data;
        });
        update();
        print('Fetched and cached yearly check data for $year');
      } else {
        print('No data fetched for this year.');
      }
    } catch (e) {
      print('Failed to fetch yearly checks: $e');
    }
  }


  // Set the selected type and print the change
  void setSelectedType(String type) {
    selectedType.value = type;
    print('Selected type updated: $type');
  }

  // 서버에서 설문 데이터를 가져오는 메서드
  Future<void> fetchPreviousSurveyAnswers(DateTime date) async {
    try {
      isLoading(true);
      List<dynamic> response =
      await _mypageRepository.getSurveyResponsesByDate(date);
      surveyResponses.value =
          response.map((data) => Survey.fromJson(data)).toList();
    } catch (e) {
      print("Error fetching survey answers: $e");
    } finally {
      isLoading(false);
    }
  }

  // 서버에서 이전 부작용 응답을 가져오는 메서드
  Future<void> fetchPreviousSideEffectAnswers(DateTime date) async {
    try {
      isLoading(true);
      List<dynamic> response =
      await _mypageRepository.getSideEffectResponsesByDate(date);
      sideEffectResponses.value =
          response.map((data) => SideEffect.fromJson(data)).toList();
    } catch (e) {
      print("Error fetching side effect answers: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchPreviousSelfRecordAnswers(DateTime date) async {
    try {
      isLoading(true);
      List<dynamic> response =
      await _mypageRepository.getSelfRecordResponsesByDate(date);
      selfRecordResponses.value =
          response.map((data) => SelfRecord.fromJson(data)).toList();
    } catch (e) {
      print("Error fetching self-record answers: $e");
    } finally {
      isLoading(false);
    }
  }

  // 생리 주기 데이터 가져오기 (연간 데이터로 수정)
  void fetchMenstruationCycles(int year) async {
    try {
      var cycles = await _mypageRepository.getMenstruationCycles(year);
      menstruationCycles.value = cycles;
      update();
    } catch (e) {
      print('Failed to fetch menstruation cycles: $e');
    }
  }

  // 특정 날짜가 생리 기간인지 확인
  bool isMenstruationDay(DateTime date) {
    for (var cycle in menstruationCycles) {
      if (!date.isBefore(cycle.startDate) && !date.isAfter(cycle.endDate)) {
        return true;
      }
    }
    return false;
  }
}
