import 'package:equatable/equatable.dart';

class AnswerChoice extends Equatable {
  final int id;
  final String answerCode;
  final String answerText;

  AnswerChoice({
    required this.id,
    required this.answerCode,
    required this.answerText,
  });

  factory AnswerChoice.fromJson(Map<String, dynamic> json) {
    return AnswerChoice(
      id: json['id'] ?? 0,
      answerCode: json['answer_code'] ?? '',
      answerText: json['answer_text'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'answer_code': answerCode,
      'answer_text': answerText,
    };
  }

  @override
  List<Object?> get props => [id, answerCode, answerText];
}
