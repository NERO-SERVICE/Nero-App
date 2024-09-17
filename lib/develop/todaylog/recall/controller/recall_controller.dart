import 'package:flutter/material.dart';

import '../../../dio_service.dart';
import '../model/question.dart';
import '../model/self_record.dart';

class RecallController with ChangeNotifier {
  final DioService _dioService = DioService();
  bool _isLoading = false;

  List<Question> surveyQuestions = [];
  List<String> surveyAnswers = [];

  List<Question> sideEffectQuestions = [];
  List<String> sideEffectAnswers = [];

  List<SelfRecord> selfLogs = [];

  bool get isLoading => _isLoading;

  Future<void> fetchSurveyQuestions() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _dioService.get('/todaylogs/questions/', params: {'type': 'survey'});
      surveyQuestions = (response.data as List)
          .map((e) => Question.fromJson(e))
          .toList();
      surveyAnswers = List<String>.filled(surveyQuestions.length, '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchSideEffectQuestions() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _dioService.get('/todaylogs/questions/', params: {'type': 'side_effect'});
      sideEffectQuestions = (response.data as List)
          .map((e) => Question.fromJson(e))
          .toList();
      sideEffectAnswers = List<String>.filled(sideEffectQuestions.length, '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchSelfLogs() async {
    _isLoading = true;
    notifyListeners();

    try {
      DateTime now = DateTime.now();
      final response = await _dioService.get('/todaylogs/self_records/', params: {
        'year': now.year.toString(),
        'month': now.month.toString().padLeft(2, '0'),
        'day': now.day.toString().padLeft(2, '0'),
      });
      selfLogs = (response.data as List)
          .map((e) => SelfRecord.fromJson(e))
          .toList();
    } catch (e) {
      print('Failed to load self logs: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

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

  void updateSurveyAnswer(int index, String answer) {
    surveyAnswers[index] = answer;
    notifyListeners();
  }

  void updateSideEffectAnswer(int index, String answer) {
    sideEffectAnswers[index] = answer;
    notifyListeners();
  }

  Future<void> submitSurveyResponses() async {
    _isLoading = true;
    notifyListeners();

    try {
      for (int i = 0; i < surveyQuestions.length; i++) {
        if (surveyAnswers[i].isNotEmpty) {
          await _dioService.post('/todaylogs/survey/', data: {
            'question_id': surveyQuestions[i].id,
            'answer': surveyAnswers[i],
          });
        }
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> submitSideEffectResponses() async {
    _isLoading = true;
    notifyListeners();

    try {
      for (int i = 0; i < sideEffectQuestions.length; i++) {
        if (sideEffectAnswers[i].isNotEmpty) {
          await _dioService.post('/todaylogs/side_effect/', data: {
            'question_id': sideEffectQuestions[i].id,
            'answer': sideEffectAnswers[i],
          });
        }
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
