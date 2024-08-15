import 'package:equatable/equatable.dart';
import 'drf_question.dart';

class DrfSurveyResponse extends Equatable {
  final int id;
  final DrfQuestion question;
  final String answer;

  DrfSurveyResponse({
    required this.id,
    required this.question,
    required this.answer,
  });

  factory DrfSurveyResponse.fromJson(Map<String, dynamic> json) {
    return DrfSurveyResponse(
      id: json['id'] ?? 0,
      question: DrfQuestion.fromJson(json['question']),
      answer: json['answer'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question.toJson(),
      'answer': answer,
    };
  }

  @override
  List<Object?> get props => [id, question, answer];
}
