import 'package:equatable/equatable.dart';
import 'question.dart';
import 'answer_choice.dart';

class Response extends Equatable {
  final int id;
  final Question question;
  final AnswerChoice? answer;
  final DateTime createdAt;
  final String responseType;

  Response({
    required this.id,
    required this.question,
    required this.answer,
    required this.createdAt,
    required this.responseType,
  });

  factory Response.fromJson(Map<String, dynamic> json) {
    return Response(
      id: json['id'] ?? 0,
      question: Question.fromJson(json['question'] ?? {}),
      answer: json['answer'] != null ? AnswerChoice.fromJson(json['answer']) : null,
      createdAt: DateTime.parse(json['created_at']),
      responseType: json['response_type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question.toJson(),
      'answer': answer?.toJson(),
      'created_at': createdAt.toIso8601String(),
      'response_type': responseType,
    };
  }

  @override
  List<Object?> get props => [id, question, answer, createdAt, responseType];
}
