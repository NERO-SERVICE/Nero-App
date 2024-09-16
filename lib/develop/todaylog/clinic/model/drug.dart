import 'package:equatable/equatable.dart';

import 'my_drug_archive.dart';

class Drug extends Equatable {
  final int drugId;
  final MyDrugArchive myDrugArchive;
  final int number;
  final int initialNumber;
  final String time;
  final bool allow;

  Drug({
    required this.drugId,
    required this.myDrugArchive,
    required this.number,
    required this.initialNumber,
    required this.time,
    required this.allow,
  });

  Drug.empty()
      : drugId = 1,
        myDrugArchive = MyDrugArchive.empty(),
        number = 0,
        initialNumber = 0,
        time = '',
        allow = true;

  factory Drug.fromJson(Map<String, dynamic> json) {
    return Drug(
      drugId: json['drugId'] ?? 1,
      myDrugArchive: MyDrugArchive.fromJson(json['myDrugArchive']),
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

  Drug copyWith({
    int? drugId,
    MyDrugArchive? myDrugArchive,
    int? number,
    int? initialNumber,
    String? time,
    bool? allow,
  }) {
    return Drug(
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
