import 'package:equatable/equatable.dart';
import 'package:nero_app/develop/todaylog/recall/model/question.dart';

class SideEffect extends Equatable {
  final int id;
  final Question question;
  final String answer;

  SideEffect({
    required this.id,
    required this.question,
    required this.answer,
  });

  factory SideEffect.fromJson(Map<String, dynamic> json) {
    return SideEffect(
      id: json['id'] ?? 0,
      question: Question.fromJson(json['question']),
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
