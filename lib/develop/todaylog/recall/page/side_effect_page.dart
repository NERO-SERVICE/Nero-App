import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:nero_app/develop/common/components/custom_loading_indicator.dart';
import 'package:nero_app/develop/common/components/custom_snackbar.dart';
import 'package:provider/provider.dart';

import '../../../common/components/custom_detail_app_bar.dart';
import '../../../common/components/custom_submit_button.dart';
import '../controller/recall_controller.dart';
import '../model/question.dart';

class SideEffectPage extends StatefulWidget {
  @override
  _SideEffectPageState createState() => _SideEffectPageState();
}

class _SideEffectPageState extends State<SideEffectPage>
    with SingleTickerProviderStateMixin {
  late SideEffectRecallController controller;
  late TabController _tabController;
  bool _isTabControllerInitialized = false;
  int _previousIndex = 0; // 이전 탭 인덱스 추적
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  void initState() {
    super.initState();

    controller = Provider.of<SideEffectRecallController>(context, listen: false);
    controller.fetchSubtypes();

    controller.addListener(() {
      if (!_isTabControllerInitialized && controller.subtypes.isNotEmpty) {
        _initializeTabController(controller);
      }
    });
  }

  void _initializeTabController(SideEffectRecallController controller) {
    _tabController = TabController(
      length: controller.subtypes.length,
      vsync: this,
    );

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        final selectedSubtype = controller.subtypes[_tabController.index];
        if (selectedSubtype.isCompleted) {
          _tabController.index = _previousIndex;
          CustomSnackbar.show(
            context: context,
            message: '이미 완료된 설문입니다.',
            isSuccess: true,
          );
        } else {
          _previousIndex = _tabController.index;
          controller.selectedSubtype = selectedSubtype.subtypeCode;
          controller.fetchQuestions();
        }
      }
    });

    _isTabControllerInitialized = true;

    // 초기 선택된 subtype에 대해 fetchQuestions() 호출
    if (controller.selectedSubtype == null && controller.subtypes.isNotEmpty) {
      // 선택되지 않은 경우 첫 번째 subtype을 선택
      controller.selectedSubtype = controller.subtypes[0].subtypeCode;
      controller.fetchQuestions();
    }
  }

  @override
  void dispose() {
    if (_isTabControllerInitialized) {
      _tabController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    analytics.logScreenView(
      screenName: 'SideEffectWritePage',
      screenClass: 'SideEffectWritePage',
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomDetailAppBar(title: '부작용 설문'),
      body: SizedBox.expand(
        child: Stack(
          children: [
            // 배경 이미지
            Positioned.fill(
              child: Image.asset(
                'assets/images/sideeffect_background.png',
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
            Consumer<SideEffectRecallController>(
              builder: (context, controller, child) {
                if (controller.isLoading && controller.subtypes.isEmpty) {
                  return Center(child: CustomLoadingIndicator());
                }

                if (!_isTabControllerInitialized && controller.subtypes.isNotEmpty) {
                  _initializeTabController(controller);
                }

                return Column(
                  children: [
                    SizedBox(height: kToolbarHeight + 80),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        '오늘 겪은 부작용을\n체계적으로 기록해보아요',
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
                          indicator: UnderlineTabIndicator(
                            borderSide: BorderSide(
                                width: 2.0, color: Color(0xffD0EE17)),
                            insets: EdgeInsets.symmetric(horizontal: 50),
                          ),
                          labelColor: Colors.white,
                          unselectedLabelColor: Color(0xffD9D9D9),
                          tabs: controller.subtypes.map((subtype) {
                            final isCompleted = subtype.isCompleted;
                            return Tab(
                              child: Text(
                                subtype.subtypeName,
                                style: TextStyle(
                                  color: isCompleted ? Color(0xff3C3C3C) : Colors.white,
                                ),
                              ),
                            );
                          }).toList(),
                          labelStyle: TextStyle(
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                          unselectedLabelStyle: TextStyle(
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ),
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
                              analytics.logEvent(
                                name: 'side_effect_registered',
                              );
                              CustomSnackbar.show(
                                context: context,
                                message: '부작용 설문이 제출되었습니다.',
                                isSuccess: true,
                              );
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
