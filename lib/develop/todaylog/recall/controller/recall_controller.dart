import 'package:flutter/material.dart';
import 'package:nero_app/develop/todaylog/recall/model/question_subtype.dart';

import '../../../dio_service.dart';
import '../model/question.dart';
import '../model/self_record.dart';

class RecallController with ChangeNotifier {
  final DioService _dioService = DioService();
  final String? type;

  RecallController({required this.type});

  bool _isLoading = false;

  // Subtypes
  List<QuestionSubtype> subtypes = [];
  String? selectedSubtype;

  // Questions and Answers
  List<Question> questions = [];
  List<int?> answers = []; // 선택된 answer_id를 저장

  // Self Logs (필요한 경우)
  List<SelfRecord> selfLogs = [];

  bool get isLoading => _isLoading;

  // 설문 Subtypes 가져오기
  Future<void> fetchSubtypes() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response =
          await _dioService.get('/todaylogs/subtypes/', params: {'type': type});
      subtypes = (response.data as List)
          .map((e) => QuestionSubtype.fromJson(e))
          .toList();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 질문 가져오기
  Future<void> fetchQuestions() async {
    if (selectedSubtype == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final response = await _dioService.get('/todaylogs/questions/', params: {
        'type': type,
        'subtype': selectedSubtype,
      });
      questions =
          (response.data as List).map((e) => Question.fromJson(e)).toList();
      answers = List<int?>.filled(questions.length, null);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 자기 기록 가져오기
  Future<void> fetchSelfLogs() async {
    _isLoading = true;
    notifyListeners();

    try {
      DateTime now = DateTime.now();
      final response =
          await _dioService.get('/todaylogs/self_records/', params: {
        'year': now.year.toString(),
        'month': now.month.toString().padLeft(2, '0'),
        'day': now.day.toString().padLeft(2, '0'),
      });
      selfLogs =
          (response.data as List).map((e) => SelfRecord.fromJson(e)).toList();
    } catch (e) {
      print('Failed to load self logs: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 자기 기록 제출하기
  Future<void> submitSelfLog(String content) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _dioService.post('/todaylogs/self_records/', data: {
        'content': content,
      });
      await fetchSelfLogs();
    } catch (e) {
      print('Failed to submit self log: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 답변 업데이트
  void updateAnswer(int index, int? answerId) {
    answers[index] = answerId;
    notifyListeners();
  }

  // 응답 제출하기
  Future<void> submitResponses() async {
    if (questions.isEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      List<Map<String, dynamic>> responses = [];
      for (int i = 0; i < questions.length; i++) {
        if (answers[i] != null) {
          responses.add({
            'question_id': questions[i].id,
            'answer_id': answers[i],
          });
        }
      }

      if (responses.isNotEmpty) {
        await _dioService.post('/todaylogs/response/', data: {
          'response_type': type,
          'responses': responses,
        });
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
