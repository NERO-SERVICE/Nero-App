import 'package:equatable/equatable.dart';

class DrfDrug extends Equatable {
  final int drugId;
  final int clinicId;
  final String status;
  final int number;
  final String time;

  DrfDrug({
    required this.drugId,
    required this.clinicId,
    required this.status,
    required this.number,
    required this.time,
  });

  DrfDrug.empty()
      : drugId = 0,
        clinicId = 0,
        status = '',
        number = 0,
        time = '';

  factory DrfDrug.fromJson(Map<String, dynamic> json) {
    return DrfDrug(
      drugId: json['drugId'] ?? 0,
      clinicId: json['item'] ?? 0,
      status: json['status'] ?? '',
      number: json['number'] ?? 0,
      time: json['time'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'drugId': drugId,
      'item': clinicId,
      'status': status,
      'number': number,
      'time': time,
    };
  }

  @override
  List<Object?> get props => [drugId, clinicId, status, number, time];
}
