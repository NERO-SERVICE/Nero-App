import 'package:equatable/equatable.dart';
import 'package:nero_app/develop/todaylog/recall/model/self_record.dart';
import 'package:nero_app/develop/todaylog/recall/model/side_effect.dart';
import 'package:nero_app/develop/todaylog/recall/model/survey.dart';

class Today extends Equatable {
  final int id;
  final int owner;
  final DateTime createdAt;
  final DateTime nextAppointmentDate;
  final List<Survey> surveyResponses;
  final List<SideEffect> sideEffectResponses;
  final List<SelfRecord> selfRecords;

  Today({
    required this.id,
    required this.owner,
    required this.createdAt,
    required this.nextAppointmentDate,
    this.surveyResponses = const [],
    this.sideEffectResponses = const [],
    this.selfRecords = const [],
  });

  factory Today.fromJson(Map<String, dynamic> json) {
    return Today(
      id: json['id'] ?? 0,
      owner: json['owner'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
      nextAppointmentDate: DateTime.parse(json['next_appointment_date']),
      surveyResponses: (json['survey_responses'] as List<dynamic>)
          .map((e) => Survey.fromJson(e))
          .toList(),
      sideEffectResponses: (json['side_effect_responses'] as List<dynamic>)
          .map((e) => SideEffect.fromJson(e))
          .toList(),
      selfRecords: (json['self_records'] as List<dynamic>)
          .map((e) => SelfRecord.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'owner': owner,
      'created_at': createdAt.toIso8601String(),
      'next_appointment_date': nextAppointmentDate.toIso8601String(),
      'survey_responses': surveyResponses.map((e) => e.toJson()).toList(),
      'side_effect_responses': sideEffectResponses.map((e) => e.toJson()).toList(),
      'self_records': selfRecords.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [
    id,
    owner,
    createdAt,
    nextAppointmentDate,
    surveyResponses,
    sideEffectResponses,
    selfRecords,
  ];
}
