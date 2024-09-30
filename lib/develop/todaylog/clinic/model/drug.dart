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

  factory Drug.fromJson(Map<String, dynamic> json) {
    return Drug(
      drugId: json['drugId'] ?? 1,
      myDrugArchive: MyDrugArchive.fromJson(json['myDrugArchive']),
      number: json['number'] ?? 0,
      initialNumber: json['initialNumber'] ?? 0,
      time: json['time'] ?? '아침',
      allow: json['allow'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'drugId': drugId,
      'myDrugArchive': myDrugArchive.toJson(),
      'number': number,
      'initialNumber': initialNumber,
      'time': time,
      'allow': allow,
    };
  }

  @override
  List<Object?> get props =>
      [drugId, myDrugArchive, number, initialNumber, time, allow];
}