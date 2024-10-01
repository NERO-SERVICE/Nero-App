import 'package:equatable/equatable.dart';
import 'answer_choice.dart';

class Question extends Equatable {
  final int id;
  final String questionText;
  final int questionType;
  final int? questionSubtype;
  final List<AnswerChoice> answerChoices;

  Question({
    required this.id,
    required this.questionText,
    required this.questionType,
    this.questionSubtype,
    this.answerChoices = const [],
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] ?? 0,
      questionText: json['question_text'] ?? '',
      questionType: json['question_type'] ?? 0,
      questionSubtype: json['question_subtype'],
      answerChoices: (json['answer_choices'] as List<dynamic>?)
          ?.map((e) => AnswerChoice.fromJson(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question_text': questionText,
      'question_type': questionType,
      'question_subtype': questionSubtype,
      'answer_choices': answerChoices.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props =>
      [id, questionText, questionType, questionSubtype, answerChoices];
}
