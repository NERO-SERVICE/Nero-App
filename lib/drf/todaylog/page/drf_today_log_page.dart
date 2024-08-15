import 'package:flutter/material.dart';
import 'package:nero_app/drf/todaylog/controller/drf_today_controller.dart';
import 'package:provider/provider.dart';

class DrfTodayLogPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DrfTodayController()..fetchSurveyQuestions(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('하루 설문'),
        ),
        body: Consumer<DrfTodayController>(
          builder: (context, controller, child) {
            if (controller.isLoading) {
              return Center(child: CircularProgressIndicator());
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: controller.surveyQuestions.length,
                      itemBuilder: (context, index) {
                        final question = controller.surveyQuestions[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(question.questionText, style: TextStyle(color: Colors.white),),
                            SizedBox(height: 8),
                            ToggleButtons(
                              isSelected: [
                                controller.surveyAnswers[index] == '1',
                                controller.surveyAnswers[index] == '2',
                                controller.surveyAnswers[index] == '3',
                                controller.surveyAnswers[index] == '4',
                                controller.surveyAnswers[index] == '5',
                              ],
                              children: [
                                Text('매우나쁨', style: TextStyle(color: Colors.white)),
                                Text('나쁨', style: TextStyle(color: Colors.white)),
                                Text('보통', style: TextStyle(color: Colors.white)),
                                Text('좋음', style: TextStyle(color: Colors.white)),
                                Text('매우좋음', style: TextStyle(color: Colors.white)),
                              ],
                              onPressed: (toggleIndex) {
                                final answer = (toggleIndex + 1).toString();
                                controller.updateSurveyAnswer(index, answer);
                              },
                            ),
                            SizedBox(height: 16),
                          ],
                        );
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await controller.submitSurveyResponses();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('설문이 제출되었습니다.')),
                      );
                    },
                    child: Text('제출'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
