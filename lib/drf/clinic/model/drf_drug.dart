import 'package:equatable/equatable.dart';

class DrfDrug extends Equatable {
  final int drugId;
  final String status;
  final int number;
  final int initialNumber;
  final String time;
  final bool allow;

  DrfDrug({
    required this.drugId,
    required this.status,
    required this.number,
    required this.initialNumber,
    required this.time,
    required this.allow,
  });

  DrfDrug.empty()
      : drugId = 0,
        status = '',
        number = 0,
        initialNumber = 0,
        time = '',
        allow = true;

  factory DrfDrug.fromJson(Map<String, dynamic> json) {
    return DrfDrug(
      drugId: json['drugId'] ?? 0,
      status: json['status'] ?? '',
      number: json['number'] ?? 0,
      initialNumber: json['initialNumber'] ?? 0,
      time: json['time'] ?? '',
      allow: json['allow'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'number': number,
      'initialNumber': initialNumber,
      'time': time,
      'allow': allow,
    };
  }

  @override
  List<Object?> get props => [drugId, status, number, initialNumber, time, allow];
}
