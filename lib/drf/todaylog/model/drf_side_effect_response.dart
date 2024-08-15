import 'package:equatable/equatable.dart';
import 'drf_question.dart';

class DrfSideEffectResponse extends Equatable {
  final int id;
  final DrfQuestion question;
  final String answer;

  DrfSideEffectResponse({
    required this.id,
    required this.question,
    required this.answer,
  });

  factory DrfSideEffectResponse.fromJson(Map<String, dynamic> json) {
    return DrfSideEffectResponse(
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
