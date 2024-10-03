import 'package:equatable/equatable.dart';
import 'response_question.dart';

class ResponseSubtype extends Equatable {
  final String subtypeCode;
  final String subtypeName;
  final List<ResponseQuestion> questions;

  ResponseSubtype({
    required this.subtypeCode,
    required this.subtypeName,
    required this.questions,
  });

  factory ResponseSubtype.fromJson(Map<String, dynamic> json) {
    return ResponseSubtype(
      subtypeCode: json['subtype_code'] ?? '',
      subtypeName: json['subtype_name'] ?? '',
      questions: (json['questions'] as List<dynamic>?)
          ?.map((q) => ResponseQuestion.fromJson(q as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }

  @override
  List<Object?> get props => [subtypeCode, subtypeName, questions];
}
