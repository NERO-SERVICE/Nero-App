import 'dart:io'; // Platform 체크를 위해 추가
import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:nero_app/develop/health/model/health_data.dart';
import 'package:nero_app/develop/health/model/health_user_info.dart';
import 'package:nero_app/develop/health/model/video_data.dart';
import 'package:nero_app/develop/health/repository/health_repository.dart';
import 'package:permission_handler/permission_handler.dart';

import '../model/predicted_steps_data.dart';

class HealthController extends ChangeNotifier {
  final Health _health = Health();
  final HealthRepository _repository = HealthRepository();

  int _todaySteps = 0;
  List<StepCount> _stepsHistory = [];
  bool _isLoading = false;
  String? _error;

  int get todaySteps => _todaySteps;
  List<StepCount> get stepsHistory => _stepsHistory;

  bool get isLoading => _isLoading;
  String? get error => _error;

  List<VideoData> _recommendedVideos = [];
  List<VideoData> get recommendedVideos => _recommendedVideos;

  HealthUserInfo? _healthUserInfo;
  HealthUserInfo? get healthUserInfo => _healthUserInfo;

  PredictedStepsData? _predictedStepsData;
  PredictedStepsData? get predictedStepsData => _predictedStepsData;

  // sportsStep 상태 변수
  String _selectedSportsStep = '준비운동'; // 기본값 설정
  String get selectedSportsStep => _selectedSportsStep;

  set selectedSportsStep(String value) {
    _selectedSportsStep = value;
    // 스포츠 단계가 변경되면 추천 동영상 초기화 및 첫 페이지 로드
    _recommendedVideos = [];
    _currentPage = 1;
    _hasMore = true;
    fetchRecommendedVideos();
    notifyListeners();
  }

  // 페이지네이션 관련 변수
  int _currentPage = 1;
  bool _hasMore = true;
  bool _isFetchingMore = false;
  bool get hasMore => _hasMore;
  bool get isFetchingMore => _isFetchingMore;

  Future<void> initialize() async {
    // 플랫폼에 따라 권한 요청 및 초기 데이터 가져오기
    bool hasPermission = await requestPermissions();
    if (hasPermission) {
      await fetchStepsHistory();
      await fetchHealthUserInfo();
      await fetchPredictedSteps();
    }
  }

  // 권한 요청 메서드
  Future<bool> requestPermissions() async {
    _isLoading = true;
    notifyListeners();
    print("HealthController: 권한 요청 중");

    if (Platform.isIOS) {
      // iOS: HealthKit 권한 요청
      final types = [HealthDataType.STEPS];
      final permissions = [HealthDataAccess.READ];

      bool hasPermissions = false;
      try {
        hasPermissions = await _health.requestAuthorization(
          types,
          permissions: permissions,
        );
      } catch (e) {
        _error = "Health 데이터 접근 권한 요청 중 오류 발생: $e";
        _isLoading = false;
        notifyListeners();
        return false;
      }

      if (!hasPermissions) {
        _error = "Health 데이터 접근 권한이 거부되었습니다.";
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } else if (Platform.isAndroid) {
      // Android: Activity Recognition 권한 요청
      final activityPermissionStatus = await Permission.activityRecognition.request();
      if (!activityPermissionStatus.isGranted) {
        _error = "활동 인식 권한이 필요합니다.";
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // 추가로 필요한 Android 권한이 있다면 여기서 요청
      // 예: 위치 권한 등
    } else {
      // 기타 플랫폼: 권한 요청 불필요 또는 지원되지 않음
      _isLoading = false;
      notifyListeners();
      return false;
    }

    _error = null;
    _isLoading = false;
    notifyListeners();
    return true;
  }

  // 걸음 수 데이터 수집 및 서버에 저장
  Future<void> collectAndSaveSteps(
      {required DateTime startDate, required DateTime endDate}) async {
    _isLoading = true;
    notifyListeners();
    print("HealthController: collectAndSaveSteps 시작");

    // 권한 확인
    bool hasPermission = await requestPermissions();
    if (!hasPermission) {
      print("HealthController: 권한이 없습니다.");
      _isLoading = false;
      notifyListeners();
      return;
    }

    // 걸음 수 데이터 가져오기
    List<HealthDataPoint> healthData = [];
    try {
      if (Platform.isIOS) {
        // iOS: HealthKit에서 데이터 가져오기
        healthData = await _health.getHealthDataFromTypes(
          startTime: startDate,
          endTime: endDate,
          types: [HealthDataType.STEPS],
        );
      } else if (Platform.isAndroid) {
        // Android: Google Fit 또는 다른 소스에서 데이터 가져오기
        // 현재 예제에서는 HealthKit과 동일하게 처리
        // 필요 시 Android용 별도 데이터 소스를 구현
        healthData = await _health.getHealthDataFromTypes(
          startTime: startDate,
          endTime: endDate,
          types: [HealthDataType.STEPS],
        );
      }
      print(
          "HealthController: 걸음 수 데이터 가져오기 성공, 데이터 개수: ${healthData.length}");
    } catch (e) {
      _error = "걸음 수 데이터 가져오기 중 오류 발생: $e";
      _isLoading = false;
      notifyListeners();
      return;
    }

    // 날짜별로 걸음 수 합산
    Map<DateTime, int> stepsPerDate = {};
    for (var data in healthData) {
      DateTime date =
      DateTime(data.dateFrom.year, data.dateFrom.month, data.dateFrom.day);
      final steps = (data.value as NumericHealthValue).numericValue.round();
      stepsPerDate.update(date, (value) => value + steps,
          ifAbsent: () => steps);
    }

    // 서버에 저장 및 로컬 변수 업데이트
    List<StepCount> stepsList = [];
    for (var entry in stepsPerDate.entries) {
      DateTime date = entry.key;
      int steps = entry.value;

      // 서버에 저장
      bool success = await _repository.sendStepsToBackend(steps, date);
      if (success) {
        stepsList.add(StepCount(id: null, date: date, steps: steps));
      } else {
        print(
            "HealthController: 서버에 걸음 수를 저장하지 못했습니다. 날짜: $date, 걸음 수: $steps");
      }
    }

    // 걸음 수 히스토리 업데이트
    _stepsHistory = stepsList;
    _error = null;
    _isLoading = false;
    notifyListeners();
    print("HealthController: 걸음 수 데이터 수집 및 저장 완료");
  }

  // 서버에서 걸음 수 히스토리 가져오기 (최근 7일 데이터만 필터링)
  Future<void> fetchStepsHistory() async {
    _isLoading = true;
    notifyListeners();
    print("HealthController: fetchStepsHistory 시작");

    try {
      // 오늘 날짜 기준으로 최근 7일
      DateTime today = DateTime.now();
      DateTime sevenDaysAgo = today.subtract(Duration(days: 6));

      // 백엔드에서 모든 데이터를 가져온 후, 최근 7일만 필터링
      List<StepCount> allSteps = await _repository.fetchStepsFromBackend();
      _stepsHistory = allSteps.where((step) {
        return step.date.isAfter(sevenDaysAgo.subtract(Duration(days: 1))) &&
            step.date.isBefore(today.add(Duration(days: 1)));
      }).toList();

      // 최근 7일 중 데이터가 없는 날짜 찾기
      List<DateTime> last7Days = List.generate(
          7,
              (index) => DateTime(
              today.year, today.month, today.day)
              .subtract(Duration(days: index)));
      last7Days = last7Days.reversed.toList(); // 오래된 날짜부터

      for (var date in last7Days) {
        bool exists =
        _stepsHistory.any((step) => isSameDate(step.date, date));
        if (!exists) {
          // 데이터가 없는 날짜에 대해 기본 걸음 수를 0으로 추가 (사용자가 수정 가능)
          _stepsHistory
              .add(StepCount(id: null, date: date, steps: 0));
        }
      }

      // 날짜 순으로 정렬
      _stepsHistory.sort((a, b) => a.date.compareTo(b.date));

      _error = null;
    } catch (e) {
      _error = "걸음 수 히스토리 가져오기 중 오류 발생: $e";
    }

    _isLoading = false;
    notifyListeners();
    print("HealthController: fetchStepsHistory 완료");
  }

  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  // 예측 걸음 수 데이터 가져오기
  Future<void> fetchPredictedSteps() async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = await _repository.fetchPredictedSteps();

      if (data.error != null) {
        _error = data.error;
      } else {
        _predictedStepsData = data;
        _error = null;
      }
    } catch (e) {
      _error = "예측 걸음 수 데이터를 가져오는 중 오류 발생: $e";
    }

    _isLoading = false;
    notifyListeners();
  }

  // HealthUserInfo 가져오기
  Future<void> fetchHealthUserInfo() async {
    _isLoading = true;
    notifyListeners();

    try {
      _healthUserInfo = await _repository.fetchHealthUserInfo();
      _error = null;
    } catch (e) {
      _error = "HealthUserInfo를 가져오는 중 오류 발생: $e";
    }

    _isLoading = false;
    notifyListeners();
  }

  // HealthUserInfo 생성 또는 업데이트
  Future<void> createOrUpdateHealthUserInfo(HealthUserInfo info) async {
    _isLoading = true;
    notifyListeners();

    try {
      _healthUserInfo = await _repository.createOrUpdateHealthUserInfo(info);
      _error = null;
    } catch (e) {
      _error = "HealthUserInfo를 저장하는 중 오류 발생: $e";
    }

    _isLoading = false;
    notifyListeners();
  }

  // 추천 동영상 가져오기 (페이지네이션)
  Future<void> fetchRecommendedVideos({bool loadMore = false}) async {
    if (_isLoading || _isFetchingMore || (!hasMore && loadMore)) return;

    if (loadMore) {
      _isFetchingMore = true;
      notifyListeners();
    } else {
      _isLoading = true;
      notifyListeners();
    }

    try {
      // 페이지 번호 계산
      final page = loadMore ? _currentPage + 1 : 1;

      final paginatedData = await _repository.fetchRecommendedVideos(
        _selectedSportsStep,
        page: page,
        pageSize: 10,
      );

      if (loadMore) {
        _recommendedVideos.addAll(paginatedData.results);
        _currentPage = page;
      } else {
        _recommendedVideos = paginatedData.results;
        _currentPage = 1;
      }

      // 다음 페이지가 있는지 확인
      _hasMore = paginatedData.next != null;

      _error = null;
    } catch (e) {
      _error = "추천 동영상을 가져오는 중 오류 발생: $e";
    } finally {
      if (loadMore) {
        _isFetchingMore = false;
      } else {
        _isLoading = false;
      }
      notifyListeners();
    }
  }

  // 특정 날짜에 걸음 수 업데이트
  Future<bool> updateSteps(int steps, DateTime date) async {
    _isLoading = true;
    notifyListeners();

    try {
      bool success = await _repository.sendStepsToBackend(steps, date);
      if (success) {
        // 로컬 stepsHistory 업데이트
        int index =
        _stepsHistory.indexWhere((step) => isSameDate(step.date, date));
        if (index != -1) {
          _stepsHistory[index] =
              StepCount(id: _stepsHistory[index].id, date: date, steps: steps);
        } else {
          _stepsHistory.add(StepCount(id: null, date: date, steps: steps));
        }
        // 날짜 순으로 정렬
        _stepsHistory.sort((a, b) => a.date.compareTo(b.date));
        _error = null;

        // 최근 7일 중 모든 날짜에 걸음 수가 존재하는지 확인
        bool allStepsPresent =
        _stepsHistory.every((step) => step.steps > 0);
        if (allStepsPresent) {
          // 모든 날짜에 걸음 수가 존재하면 알고리즘 재실행
          await fetchPredictedSteps();
          await fetchHealthUserInfo();
        }

        notifyListeners();
        return true;
      } else {
        _error = "서버에 걸음 수를 저장하지 못했습니다.";
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = "걸음 수를 업데이트하는 중 오류 발생: $e";
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}