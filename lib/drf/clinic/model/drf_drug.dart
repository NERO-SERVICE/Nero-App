import 'package:equatable/equatable.dart';
import 'drf_my_drug_archive.dart';

class DrfDrug extends Equatable {
  final int drugId;
  final DrfMyDrugArchive myDrugArchive;
  final int number;
  final int initialNumber;
  final String time;
  final bool allow;

  DrfDrug({
    required this.drugId,
    required this.myDrugArchive,
    required this.number,
    required this.initialNumber,
    required this.time,
    required this.allow,
  });

  DrfDrug.empty()
      : drugId = 1,
        myDrugArchive = DrfMyDrugArchive.empty(),
        number = 0,
        initialNumber = 0,
        time = '',
        allow = true;

  factory DrfDrug.fromJson(Map<String, dynamic> json) {
    return DrfDrug(
      drugId: json['drugId'] ?? 1,
      myDrugArchive: DrfMyDrugArchive.fromJson(json['myDrugArchive']),
      number: json['number'] ?? 0,
      initialNumber: json['initialNumber'] ?? 0,
      time: json['time'] ?? '',
      allow: json['allow'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'myDrugArchive': myDrugArchive.toJson(),
      'number': number,
      'initialNumber': initialNumber,
      'time': time,
      'allow': allow,
    };
  }

  DrfDrug copyWith({
    int? drugId,
    DrfMyDrugArchive? myDrugArchive,
    int? number,
    int? initialNumber,
    String? time,
    bool? allow,
  }) {
    return DrfDrug(
      drugId: drugId ?? this.drugId,
      myDrugArchive: myDrugArchive ?? this.myDrugArchive,
      number: number ?? this.number,
      initialNumber: initialNumber ?? this.initialNumber,
      time: time ?? this.time,
      allow: allow ?? this.allow,
    );
  }

  @override
  List<Object?> get props =>
      [drugId, myDrugArchive, number, initialNumber, time, allow];
}
