import 'package:flutter/material.dart';
import 'package:nero_app/drf/todaylog/controller/drf_today_controller.dart';
import 'package:provider/provider.dart';

class DrfTodaySideEffectPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DrfTodayController()..fetchSideEffectQuestions(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('부작용 기록'),
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
                      itemCount: controller.sideEffectQuestions.length,
                      itemBuilder: (context, index) {
                        final question = controller.sideEffectQuestions[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(question.questionText, style: TextStyle(color: Colors.white)),
                            SizedBox(height: 8),
                            ToggleButtons(
                              isSelected: [
                                controller.sideEffectAnswers[index] == '1',
                                controller.sideEffectAnswers[index] == '2',
                                controller.sideEffectAnswers[index] == '3',
                                controller.sideEffectAnswers[index] == '4',
                                controller.sideEffectAnswers[index] == '5',
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
                                controller.updateSideEffectAnswer(index, answer);
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
                      await controller.submitSideEffectResponses();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('부작용 기록이 제출되었습니다.')),
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
