import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nero_app/develop/common/components/custom_detail_app_bar.dart';
import 'package:nero_app/develop/common/components/custom_loading_indicator.dart';
import 'package:nero_app/develop/mypage/controller/mypage_controller.dart';

class UserSideEffectLogPage extends StatelessWidget {
  final DateTime selectedDate;

  UserSideEffectLogPage({required this.selectedDate});

  final MypageController _controller = Get.find<MypageController>();

  @override
  Widget build(BuildContext context) {
    _controller.fetchPreviousSideEffectAnswers(selectedDate);
    String formattedDate = DateFormat('yy년 MM월 dd일').format(selectedDate);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomDetailAppBar(
        title: '$formattedDate 부작용 설문',
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
          // 컨텐츠
          Obx(() {
            if (_controller.isLoading.value) {
              return Center(child: CustomLoadingIndicator());
            }

            if (_controller.sideEffectResponses.isEmpty) {
              return Center(
                child: Text(
                  '해당 날짜에 기록된 내용이 없습니다.',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Color(0xffD9D9D9),
                  ),
                ),
              );
            }

            return Column(
              children: [
                SizedBox(height: kToolbarHeight + 56),
                Expanded(
                  child: Theme(
                    // Theme to remove divider color in ExpansionTile
                    data: Theme.of(context)
                        .copyWith(dividerColor: Colors.transparent),
                    child: ListView.builder(
                      padding: EdgeInsets.all(16),
                      itemCount: _controller.sideEffectResponses.length,
                      itemBuilder: (context, index) {
                        final subtype = _controller.sideEffectResponses[index];
                        return Card(
                          color: Color(0xff202020).withOpacity(0.2),
                          margin: EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                          child: ExpansionTile(
                            iconColor: Colors.white,
                            collapsedIconColor: Colors.white,
                            title: Text(
                              subtype.subtypeName,
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            backgroundColor: Colors.transparent,
                            collapsedBackgroundColor: Colors.transparent,
                            maintainState: true,
                            children: subtype.questions.map((question) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // 질문 텍스트
                                    Text(
                                      'Q. ${question.questionText}',
                                      style: TextStyle(
                                        fontFamily: 'Pretendard',
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        color: Color(0xffD9D9D9),
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    SizedBox(height: 5),
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        children: [
                                          Icon(
                                            question.answerText == '답변이 없습니다.'
                                                ? Icons.cancel
                                                : Icons.check_circle,
                                            color: question.answerText ==
                                                    '답변이 없습니다.'
                                                ? Color(0xffD9D9D9)
                                                    .withOpacity(0.5)
                                                : Colors.white,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            question.answerText,
                                            style: TextStyle(
                                              color: question.answerText ==
                                                      '답변이 없습니다.'
                                                  ? Color(0xffD9D9D9)
                                                      .withOpacity(0.5)
                                                  : Colors.white,
                                              fontFamily: 'Pretendard',
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
