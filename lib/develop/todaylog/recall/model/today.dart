import 'package:equatable/equatable.dart';
import 'self_record.dart';
import 'response.dart';

class Today extends Equatable {
  final int id;
  final DateTime createdAt;
  final DateTime? nextAppointmentDate;
  final List<Response> responses;
  final List<SelfRecord> selfRecords;

  Today({
    required this.id,
    required this.createdAt,
    this.nextAppointmentDate,
    this.responses = const [],
    this.selfRecords = const [],
  });

  factory Today.fromJson(Map<String, dynamic> json) {
    List<Response> allResponses = (json['responses'] as List<dynamic>?)
        ?.map((e) => Response.fromJson(e))
        .toList() ??
        [];

    return Today(
      id: json['id'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
      nextAppointmentDate: json['next_appointment_date'] != null
          ? DateTime.parse(json['next_appointment_date'])
          : null,
      responses: allResponses,
      selfRecords: (json['self_records'] as List<dynamic>?)
          ?.map((e) => SelfRecord.fromJson(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'next_appointment_date': nextAppointmentDate?.toIso8601String(),
      'responses': responses.map((e) => e.toJson()).toList(),
      'self_records': selfRecords.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [
    id,
    createdAt,
    nextAppointmentDate,
    responses,
    selfRecords,
  ];
}
