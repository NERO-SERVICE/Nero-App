import 'package:equatable/equatable.dart';
import 'drf_drug_archive.dart';

class DrfDrug extends Equatable {
  final int drugId;
  final DrfDrugArchive drugArchive;
  final int number;
  final int initialNumber;
  final String time;
  final bool allow;

  DrfDrug({
    required this.drugId,
    required this.drugArchive,
    required this.number,
    required this.initialNumber,
    required this.time,
    required this.allow,
  });

  DrfDrug.empty()
      : drugId = 1,
        drugArchive = DrfDrugArchive.empty(),
        number = 0,
        initialNumber = 0,
        time = '',
        allow = true;

  factory DrfDrug.fromJson(Map<String, dynamic> json) {
    return DrfDrug(
      drugId: json['drugId'] ?? 1,
      drugArchive: DrfDrugArchive.fromJson(json['drugArchive']),
      number: json['number'] ?? 0,
      initialNumber: json['initialNumber'] ?? 0,
      time: json['time'] ?? '',
      allow: json['allow'] ?? true,
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'drugArchive': drugArchive.id,
      'number': number,
      'initialNumber': initialNumber,
      'time': time,
      'allow': allow,
    };
  }

  DrfDrug copyWith({
    int? drugId,
    DrfDrugArchive? drugArchive,
    int? number,
    int? initialNumber,
    String? time,
    bool? allow,
  }) {
    return DrfDrug(
      drugId: drugId ?? this.drugId,
      drugArchive: drugArchive ?? this.drugArchive,
      number: number ?? this.number,
      initialNumber: initialNumber ?? this.initialNumber,
      time: time ?? this.time,
      allow: allow ?? this.allow,
    );
  }

  @override
  List<Object?> get props =>
      [drugId, drugArchive, number, initialNumber, time, allow];
}
