import 'package:equatable/equatable.dart';

class ResponseQuestion extends Equatable {
  final String questionText;
  final String answerText;

  ResponseQuestion({
    required this.questionText,
    required this.answerText,
  });

  factory ResponseQuestion.fromJson(Map<String, dynamic> json) {
    return ResponseQuestion(
      questionText: json['question_text'] ?? '',
      answerText: json['answer_text'] ?? '',
    );
  }

  @override
  List<Object?> get props => [questionText, answerText];
}
