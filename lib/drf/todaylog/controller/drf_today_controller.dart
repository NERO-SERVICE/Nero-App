import 'package:flutter/material.dart';
import 'package:nero_app/drf/dio_service.dart';
import 'package:nero_app/drf/todaylog/model/drf_question.dart';
import 'package:nero_app/drf/todaylog/model/drf_self_record.dart';

class DrfTodayController with ChangeNotifier {
  final DioService _dioService = DioService();
  bool _isLoading = false;

  List<DrfQuestion> surveyQuestions = [];
  List<String> surveyAnswers = [];

  List<DrfQuestion> sideEffectQuestions = [];
  List<String> sideEffectAnswers = [];

  List<DrfSelfRecord> selfLogs = [];

  bool get isLoading => _isLoading;

  Future<void> fetchSurveyQuestions() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _dioService.get('/todaylogs/questions/', params: {'type': 'survey'});
      surveyQuestions = (response.data as List)
          .map((e) => DrfQuestion.fromJson(e))
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
          .map((e) => DrfQuestion.fromJson(e))
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
          .map((e) => DrfSelfRecord.fromJson(e))
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
      await fetchSelfLogs();  // Re-fetch logs to update the UI
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
