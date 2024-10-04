import 'package:equatable/equatable.dart';

class MonthlyCheck extends Equatable {
  final String month;
  final Map<int, bool> doseCheck;
  final Map<int, bool> sideEffectCheck;
  final int monthStart;
  final int monthEnd;

  MonthlyCheck({
    required this.month,
    required this.doseCheck,
    required this.sideEffectCheck,
    required this.monthStart,
    required this.monthEnd,
  });

  MonthlyCheck.empty()
      : month = '',
        doseCheck = {},
        sideEffectCheck = {},
        monthStart = 0,
        monthEnd = 0;

  factory MonthlyCheck.fromJson(Map<String, dynamic> json) {
    // 데이터의 키를 int로 변환하여 저장
    return MonthlyCheck(
      month: json['month'] ?? '',
      doseCheck: (json['doseCheck'] as Map<String, dynamic>)
          .map((key, value) => MapEntry(int.parse(key), value)),
      sideEffectCheck: (json['sideEffectCheck'] as Map<String, dynamic>)
          .map((key, value) => MapEntry(int.parse(key), value)),
      monthStart: json['monthStart'] ?? 0,
      monthEnd: json['monthEnd'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'month': month,
      'doseCheck': doseCheck,
      'sideEffectCheck': sideEffectCheck,
      'monthStart': monthStart,
      'monthEnd': monthEnd,
    };
  }

  @override
  List<Object?> get props => [
    month,
    doseCheck,
    sideEffectCheck,
    monthStart,
    monthEnd,
  ];
}
