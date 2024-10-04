import 'package:get/get.dart';
import 'package:nero_app/develop/common/components/custom_snackbar.dart';
import 'package:nero_app/develop/mypage/repository/mypage_repository.dart';
import 'package:nero_app/develop/todaylog/recall/model/response_subtype.dart';

import '../../todaylog/recall/model/self_record.dart';
import '../model/menstruation_cycle.dart';
import '../model/monthly_check.dart';

class MypageController extends GetxController {
  final MypageRepository _mypageRepository = MypageRepository();
  var selectedType = 'all'.obs;

  var isLoading = true.obs;
  var surveyResponses = <ResponseSubtype>[].obs;
  var sideEffectResponses = <ResponseSubtype>[].obs;
  var selfRecordResponses = <SelfRecord>[].obs;
  var menstruationCycles = <MenstruationCycle>[].obs;

  Map<String, MonthlyCheck> monthlyCheckCache = {};
  var surveyRecordedDates = <DateTime>{}.obs;
  var sideEffectRecordedDates = <DateTime>{}.obs;
  var selfRecordRecordedDates = <DateTime>{}.obs;

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
      List<ResponseSubtype> response =
      await _mypageRepository.getSurveyResponsesByDate(date);
      surveyResponses.value = response;
    } catch (e) {
      print("Error fetching side effect answers: $e");
    } finally {
      isLoading(false);
    }
  }

  // 서버에서 이전 부작용 응답을 가져오는 메서드
  Future<void> fetchPreviousSideEffectAnswers(DateTime date) async {
    try {
      isLoading(true);
      List<ResponseSubtype> response =
      await _mypageRepository.getSideEffectResponsesByDate(date);
      sideEffectResponses.value = response;
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

  // 생리 주기 생성 메서드 추가
  Future<void> createMenstruationCycle(MenstruationCycle cycle) async {
    try {
      bool success = await _mypageRepository.createMenstruationCycle(cycle);
      if (success) {
        // 생리 주기 리스트를 다시 불러옵니다.
        fetchMenstruationCycles(cycle.startDate.year);

        // 성공 스낵바 먼저 호출
        CustomSnackbar.show(
          context: Get.context!,
          message: '생리 주기가 추가되었습니다.',
          isSuccess: true,
        );

        // 이후 다이얼로그 닫기
        Get.back();
      } else {
        CustomSnackbar.show(
          context: Get.context!,
          message: '생리 주기를 추가하지 못했습니다',
          isSuccess: false,
        );
      }
    } catch (e) {
      CustomSnackbar.show(
        context: Get.context!,
        message: '생리 주기 추가에 실패했습니다.',
        isSuccess: false,
      );
    }
  }

  Future<void> fetchSurveyRecordedDates(int year) async {
    try {
      var dates = await _mypageRepository.getSurveyRecordedDates(year);
      surveyRecordedDates.addAll(dates);
    } catch (e) {
      print("Error fetching survey recorded dates: $e");
    }
  }

  Future<void> fetchSideEffectRecordedDates(int year) async {
    try {
      var dates = await _mypageRepository.getSideEffectRecordedDates(year);
      sideEffectRecordedDates.addAll(dates);
    } catch (e) {
      print("Error fetching side effect recorded dates: $e");
    }
  }

  Future<void> fetchSelfRecordRecordedDates(int year) async {
    try {
      var dates = await _mypageRepository.getSelfRecordRecordedDates(year);
      selfRecordRecordedDates.addAll(dates);
    } catch (e) {
      print("Error fetching self-record recorded dates: $e");
    }
  }
}
