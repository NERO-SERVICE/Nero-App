import 'package:equatable/equatable.dart';

class Question extends Equatable {
  final int id;
  final String questionText;
  final String questionType;

  Question({
    required this.id,
    required this.questionText,
    required this.questionType,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] ?? 0,
      questionText: json['question_text'] ?? '',
      questionType: json['question_type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question_text': questionText,
      'question_type': questionType,
    };
  }

  @override
  List<Object?> get props => [id, questionText, questionType];
}
