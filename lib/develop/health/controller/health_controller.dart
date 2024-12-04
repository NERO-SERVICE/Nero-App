import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:nero_app/develop/health/model/health.dart';
import 'package:nero_app/develop/health/model/health_user_info.dart';
import 'package:nero_app/develop/health/model/video_data.dart';
import 'package:nero_app/develop/health/repository/health_repository.dart';
import 'package:permission_handler/permission_handler.dart';

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

  // **Public getter** for _hasMore
  bool get hasMore => _hasMore;

  // **Public getter** for _isFetchingMore (optional)
  bool get isFetchingMore => _isFetchingMore;

  Future<void> initialize() async {
    await fetchStepsHistory();
    await fetchHealthUserInfo();
    // 추천 동영상은 사용자가 sports_step을 선택할 때 가져옵니다.
  }

  // 권한 요청 메서드
  Future<bool> requestPermissions() async {
    _isLoading = true;
    notifyListeners();
    print("HealthController: 권한 요청 중");

    // 권한 요청을 위한 데이터 타입과 접근 권한 설정
    final types = [HealthDataType.STEPS];
    final permissions = [HealthDataAccess.READ];

    // 활동 인식 권한 요청
    final activityPermissionStatus =
    await Permission.activityRecognition.request();
    if (!activityPermissionStatus.isGranted) {
      _error = "활동 인식 권한이 필요합니다.";
      _isLoading = false;
      notifyListeners();
      return false;
    }

    // Health 패키지 권한 요청
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
      healthData = await _health.getHealthDataFromTypes(
        types: [HealthDataType.STEPS],
        startTime: startDate,
        endTime: endDate,
      );
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

  // 서버에서 걸음 수 히스토리 가져오기
  Future<void> fetchStepsHistory() async {
    _isLoading = true;
    notifyListeners();
    print("HealthController: fetchStepsHistory 시작");

    try {
      _stepsHistory = await _repository.fetchStepsFromBackend();
      _error = null;
    } catch (e) {
      _error = "걸음 수 히스토리 가져오기 중 오류 발생: $e";
    }

    _isLoading = false;
    notifyListeners();
    print("HealthController: fetchStepsHistory 완료");
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
}
