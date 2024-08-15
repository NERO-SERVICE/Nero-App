import 'package:equatable/equatable.dart';
import 'drf_survey_response.dart';
import 'drf_side_effect_response.dart';
import 'drf_self_record.dart';

class DrfToday extends Equatable {
  final int id;
  final int owner;
  final DateTime createdAt;
  final DateTime nextAppointmentDate;
  final List<DrfSurveyResponse> surveyResponses;
  final List<DrfSideEffectResponse> sideEffectResponses;
  final List<DrfSelfRecord> selfRecords;

  DrfToday({
    required this.id,
    required this.owner,
    required this.createdAt,
    required this.nextAppointmentDate,
    this.surveyResponses = const [],
    this.sideEffectResponses = const [],
    this.selfRecords = const [],
  });

  factory DrfToday.fromJson(Map<String, dynamic> json) {
    return DrfToday(
      id: json['id'] ?? 0,
      owner: json['owner'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
      nextAppointmentDate: DateTime.parse(json['next_appointment_date']),
      surveyResponses: (json['survey_responses'] as List<dynamic>)
          .map((e) => DrfSurveyResponse.fromJson(e))
          .toList(),
      sideEffectResponses: (json['side_effect_responses'] as List<dynamic>)
          .map((e) => DrfSideEffectResponse.fromJson(e))
          .toList(),
      selfRecords: (json['self_records'] as List<dynamic>)
          .map((e) => DrfSelfRecord.fromJson(e))
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
