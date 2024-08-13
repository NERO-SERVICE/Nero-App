import 'package:equatable/equatable.dart';

import 'drf_drug.dart';

class DrfClinic extends Equatable {
  final int clinicId;
  final int owner;
  final DateTime recentDay;
  final DateTime nextDay;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String title;
  final List<DrfDrug> drugs;

  DrfClinic({
    required this.clinicId,
    required this.owner,
    required this.recentDay,
    required this.nextDay,
    required this.createdAt,
    required this.updatedAt,
    required this.title,
    this.drugs = const [],
  });

  DrfClinic.empty()
      : clinicId = 0,
        owner = 0,
        recentDay = DateTime.now(),
        nextDay = DateTime.now(),
        createdAt = DateTime.now(),
        updatedAt = DateTime.now(),
        title = '',
        drugs = [];

  factory DrfClinic.fromJson(Map<String, dynamic> json) {
    return DrfClinic(
      clinicId: json['clinicId'] ?? 0,
      owner: json['owner'] ?? 0,
      recentDay: DateTime.parse(json['recentDay']),
      nextDay: DateTime.parse(json['nextDay']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      title: json['title'] ?? '',
      drugs: (json['drugs'] as List<dynamic>)
          .map((e) => DrfDrug.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'clinicId': clinicId,
      'owner': owner,
      'recentDay': recentDay.toIso8601String(),
      'nextDay': nextDay.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'title': title,
      'drugs': drugs.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [
        clinicId,
        owner,
        recentDay,
        nextDay,
        createdAt,
        updatedAt,
        title,
        drugs,
      ];
}
