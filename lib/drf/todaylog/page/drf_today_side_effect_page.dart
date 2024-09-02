import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:nero_app/drf/todaylog/controller/drf_today_controller.dart';
import 'package:provider/provider.dart';

class DrfTodaySideEffectPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DrfTodayController()..fetchSideEffectQuestions(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: Icon(Icons.chevron_left, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/sideeffect_background.png',
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.center,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.9),
                    ],
                  ),
                ),
              ),
            ),
            Consumer<DrfTodayController>(
              builder: (context, controller, child) {
                if (controller.isLoading) {
                  return Center(child: CircularProgressIndicator());
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: kToolbarHeight + 29),
                      Text(
                        '부작용 기록',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w600,
                          fontSize: 25,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 13),
                      Text(
                        '오늘 겪은 부작용을 기록해주세요',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: Color(0xffD9D9D9),
                        ),
                      ),
                      SizedBox(height: 20),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: controller.sideEffectQuestions.length,
                        itemBuilder: (context, index) {
                          final question = controller.sideEffectQuestions[index];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                question.questionText,
                                style: TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 22,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 40),
                              _buildToggleButtons(
                                context,
                                controller: controller,
                                index: index,
                              ),
                              SizedBox(height: 70),
                            ],
                          );
                        },
                      ),
                      SizedBox(height: 26),
                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            await controller.submitSideEffectResponses();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('부작용 기록이 제출되었습니다.')),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.withOpacity(0.3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 66.0),
                          ),
                          child: Text(
                            '제출하기',
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w500,
                              fontSize: 25,
                              color: Color(0xffD9D9D9),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 26),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButtons(
      BuildContext context, {
        required DrfTodayController controller,
        required int index,
      }) {
    final options = ['매우나쁨', '나쁨', '보통', '좋음', '매우좋음'];

    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      alignment: WrapAlignment.center,
      children: List.generate(options.length, (optionIndex) {
        final isSelected =
            controller.sideEffectAnswers[index] == (optionIndex + 1).toString();
        return GestureDetector(
          onTap: () {
            final answer = (optionIndex + 1).toString();
            controller.updateSideEffectAnswer(index, answer);
          },
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color:
              isSelected ? Color(0xff1C1B1B) : Colors.grey.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              options[optionIndex],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w500,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
        );
      }),
    );
  }
}
