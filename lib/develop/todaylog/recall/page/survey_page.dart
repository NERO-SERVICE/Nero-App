// survey_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/components/custom_detail_app_bar.dart';
import '../../../common/components/custom_loading_indicator.dart';
import '../../../common/components/custom_submit_button.dart';
import '../controller/recall_controller.dart';
import '../model/question.dart';

class SurveyPage extends StatefulWidget {
  @override
  _SurveyPageState createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isTabControllerInitialized = false;
  int _previousIndex = 0;

  @override
  void dispose() {
    if (_isTabControllerInitialized) {
      _tabController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RecallController(type: 'survey')..fetchSubtypes(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: CustomDetailAppBar(title: '하루 설문'),
        body: SizedBox.expand(
          child: Stack(
            children: [
              // 배경 이미지
              Positioned.fill(
                child: Image.asset(
                  'assets/images/today_background.png',
                  fit: BoxFit.cover,
                ),
              ),
              // 그라데이션 오버레이
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
              // 컨텐츠
              Consumer<RecallController>(
                builder: (context, controller, child) {
                  if (controller.isLoading && controller.subtypes.isEmpty) {
                    return Center(child: CustomLoadingIndicator());
                  }

                  // TabController 초기화
                  if (!_isTabControllerInitialized &&
                      controller.subtypes.isNotEmpty) {
                    _tabController = TabController(
                      length: controller.subtypes.length,
                      vsync: this,
                    );

                    _tabController.addListener(() {
                      if (_tabController.indexIsChanging) {
                        final selectedSubtype =
                            controller.subtypes[_tabController.index];
                        if (selectedSubtype.isCompleted) {
                          // 비활성화된 탭 선택 시 이전 탭으로 되돌리고 메시지 표시
                          _tabController.index = _previousIndex;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('이미 완료된 설문입니다.')),
                          );
                        } else {
                          // 정상적으로 탭 선택 시 이전 인덱스 업데이트
                          _previousIndex = _tabController.index;
                          controller.selectedSubtype =
                              selectedSubtype.subtypeCode;
                          controller.fetchQuestions();
                        }
                      }
                    });

                    // 초기 선택 설정
                    if (controller.selectedSubtype == null &&
                        controller.subtypes.isNotEmpty) {
                      int initialIndex =
                          controller.subtypes.indexWhere((s) => !s.isCompleted);
                      if (initialIndex == -1) {
                        // 모든 탭이 완료된 경우
                        return Center(
                          child: Text(
                            '모든 설문조사가 완료되었습니다.',
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Color(0xffD9D9D9),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        );
                      }
                      _tabController.index = initialIndex;
                      controller.selectedSubtype =
                          controller.subtypes[initialIndex].subtypeCode;
                      controller.fetchQuestions();
                      _previousIndex = initialIndex;
                    }

                    _isTabControllerInitialized = true;
                  }

                  return Column(
                    children: [
                      SizedBox(height: kToolbarHeight + 56),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          '오늘 당신의 하루가 어땠는지\n저에게 알려주세요',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Color(0xffD9D9D9),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 20),
                      if (controller.subtypes.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: TabBar(
                            controller: _tabController,
                            isScrollable: false,
                            // 탭들이 화면 너비에 맞게 고르게 분포
                            indicator: UnderlineTabIndicator(
                              borderSide: BorderSide(
                                  width: 2.0, color: Color(0xffD0EE17)),
                              insets: EdgeInsets.symmetric(
                                  horizontal: 50), // 인디케이터 길이 조정
                            ),
                            labelColor: Colors.white,
                            unselectedLabelColor: Color(0xffD9D9D9),
                            tabs: controller.subtypes.map((subtype) {
                              final isCompleted = subtype.isCompleted;
                              return Tab(
                                child: Text(
                                  subtype.subtypeName,
                                  style: TextStyle(
                                    color: isCompleted
                                        ? Color(0xff3C3C3C)
                                        : Colors.white,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      SizedBox(height: 20),
                      // 질문 및 답변
                      Expanded(
                        child: controller.isLoading &&
                                controller.questions.isEmpty
                            ? Center(child: CustomLoadingIndicator())
                            : controller.questions.isEmpty
                                ? Center(
                                    child: Text(
                                      '질문이 없습니다.',
                                      style:
                                          TextStyle(color: Color(0xffD9D9D9)),
                                    ),
                                  )
                                : SingleChildScrollView(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 32, vertical: 16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: List.generate(
                                          controller.questions.length, (index) {
                                        final question =
                                            controller.questions[index];
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            // 질문 앞에 인덱스 추가
                                            Text(
                                              '${index + 1}. ${question.questionText}',
                                              style: TextStyle(
                                                fontFamily: 'Pretendard',
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                                color: Colors.white,
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                            SizedBox(height: 18),
                                            _buildAnswerChoices(
                                              context,
                                              controller: controller,
                                              index: index,
                                              question: question,
                                            ),
                                            SizedBox(height: 60),
                                          ],
                                        );
                                      }),
                                    ),
                                  ),
                      ),
                      // 제출 버튼
                      if (controller.questions.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 30),
                          child: Center(
                            child: CustomSubmitButton(
                              onPressed: () async {
                                await controller.submitResponses();
                                final snackBar = SnackBar(
                                  content: Text('하루 설문이 제출되었습니다.'),
                                  duration: Duration(seconds: 1),
                                );

                                final snackBarController =
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);

                                await snackBarController.closed;
                                Navigator.pop(context);
                              },
                              text: '제출하기',
                              isEnabled: true,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnswerChoices(
    BuildContext context, {
    required RecallController controller,
    required int index,
    required Question question,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: question.answerChoices.map((answerChoice) {
        final isSelected = controller.answers[index] == answerChoice.id;
        return GestureDetector(
          onTap: () {
            controller.updateAnswer(index, answerChoice.id);
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            width: 150,
            height: 40,
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? Color(0xff1C1B1B)
                  : Color(0xff000000).withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: Text(
              answerChoice.answerText,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w500,
                fontSize: 12,
                color: isSelected
                    ? Color(0xffFFFFFF)
                    : Color(0xffFFFFFF).withOpacity(0.8),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
