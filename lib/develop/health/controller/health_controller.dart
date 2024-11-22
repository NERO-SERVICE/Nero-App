import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:nero_app/develop/health/model/health.dart';
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

  /// 권한 요청 메서드
  Future<bool> requestPermissions() async {
    _isLoading = true;
    notifyListeners();
    print("HealthController: 권한 요청 중");

    // 권한 요청을 위한 데이터 타입과 접근 권한 설정
    final types = [HealthDataType.STEPS];
    final permissions = [HealthDataAccess.READ];

    // 활동 인식 권한 요청
    final activityPermissionStatus = await Permission.activityRecognition.request();
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

  /// 걸음 수 데이터 수집 및 서버에 저장
  Future<void> collectAndSaveSteps({required DateTime startDate, required DateTime endDate}) async {
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
      print("HealthController: 걸음 수 데이터 가져오기 성공, 데이터 개수: ${healthData.length}");
    } catch (e) {
      _error = "걸음 수 데이터 가져오기 중 오류 발생: $e";
      _isLoading = false;
      notifyListeners();
      return;
    }

    // 날짜별로 걸음 수 합산
    Map<DateTime, int> stepsPerDate = {};
    for (var data in healthData) {
      DateTime date = DateTime(data.dateFrom.year, data.dateFrom.month, data.dateFrom.day);
      final steps = (data.value as NumericHealthValue).numericValue.round();
      stepsPerDate.update(date, (value) => value + steps, ifAbsent: () => steps);
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
        print("HealthController: 서버에 걸음 수를 저장하지 못했습니다. 날짜: $date, 걸음 수: $steps");
      }
    }

    // 걸음 수 히스토리 업데이트
    _stepsHistory = stepsList;
    _error = null;
    _isLoading = false;
    notifyListeners();
    print("HealthController: 걸음 수 데이터 수집 및 저장 완료");
  }

  /// 서버에서 걸음 수 히스토리 가져오기
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

  /// 초기화 메서드
  Future<void> initialize() async {
    print("HealthController: initialize 시작");
    await fetchStepsHistory();
    print("HealthController: initialize 완료");
  }
}
