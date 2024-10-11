import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nero_app/develop/dio_service.dart';
import 'package:nero_app/develop/todaylog/recall/model/question_subtype.dart';
import 'package:nero_app/develop/todaylog/recall/model/question.dart';
import 'package:nero_app/develop/todaylog/recall/model/self_record.dart';

class RecallController with ChangeNotifier {
  final DioService _dioService = Get.find<DioService>();
  final String? type;

  RecallController({required this.type});

  bool _isLoading = false;

  // Subtypes
  List<QuestionSubtype> subtypes = [];
  String? selectedSubtype;
  Set<String> completedSubtypes = {};

  List<Question> questions = [];
  List<int?> answers = [];
  List<SelfRecord> selfLogs = [];
  bool get isLoading => _isLoading;

  Future<void> fetchCompletedSubtypes() async {
    try {
      final response = await _dioService.get('/todaylogs/survey_completions/', params: {
        'year': DateTime.now().year.toString(),
        'month': DateTime.now().month.toString().padLeft(2, '0'),
        'day': DateTime.now().day.toString().padLeft(2, '0'),
        'response_type': type,
      });

      completedSubtypes = (response.data as List)
          .map<String>((e) => e['question_subtype'])
          .toSet();
    } catch (e) {
      print('Failed to fetch completed subtypes: $e');
    }
  }


  Future<void> fetchSubtypes() async {
    _isLoading = true;
    notifyListeners();

    try {
      await fetchCompletedSubtypes();

      final response = await _dioService.get('/todaylogs/subtypes/', params: {
        'type': type,
        'response_type': type,
      });

      subtypes = (response.data as List)
          .map<QuestionSubtype>((e) => QuestionSubtype.fromJson(e))
          .toList();

      for (var subtype in subtypes) {
        if (completedSubtypes.contains(subtype.subtypeCode)) {
          subtype.isCompleted = true;
        }
      }
    } catch (e) {
      print('Failed to fetch subtypes: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  Future<void> fetchQuestions() async {
    if (selectedSubtype == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final response = await _dioService.get('/todaylogs/questions/', params: {
        'type': type,
        'subtype': selectedSubtype,
      });
      questions = (response.data as List).map((e) => Question.fromJson(e)).toList();
      answers = List<int?>.filled(questions.length, null);
    } catch (e) {
      print('Failed to fetch questions: $e');
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
      selfLogs = (response.data as List).map((e) => SelfRecord.fromJson(e)).toList();
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


  void updateAnswer(int index, int? answerId) {
    answers[index] = answerId;
    notifyListeners();
  }


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
        final response = await _dioService.post('/todaylogs/response/', data: {
          'response_type': type,
          'responses': responses,
        });
        await fetchSubtypes();

        questions = [];
        answers = [];
        selectedSubtype = null;
      }
    } catch (e) {
      print('Failed to submit responses: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

class SideEffectRecallController extends RecallController {
  SideEffectRecallController() : super(type: 'side_effect');
}

class SurveyRecallController extends RecallController {
  SurveyRecallController() : super(type: 'survey');
}