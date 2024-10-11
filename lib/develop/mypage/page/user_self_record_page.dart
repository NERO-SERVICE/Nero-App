import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nero_app/develop/common/components/custom_detail_app_bar.dart';
import 'package:nero_app/develop/mypage/controller/mypage_controller.dart';
import 'package:nero_app/develop/todaylog/recall/model/self_record.dart';

import '../../common/components/custom_loading_indicator.dart';

class UserSelfRecordPage extends StatelessWidget {
  final DateTime selectedDate;
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  UserSelfRecordPage({required this.selectedDate});

  @override
  Widget build(BuildContext context) {
    analytics.logScreenView(
      screenName: 'MyPageSelfRecordLogPage',
      screenClass: 'MyPageSelfRecordLogPage',
    );
    final MypageController controller = Get.put(MypageController());

    controller.fetchPreviousSelfRecordAnswers(selectedDate);
    String formattedDate = DateFormat('yy년 MM월 dd일').format(selectedDate);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomDetailAppBar(
        title: '$formattedDate 셀프 기록',
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/selflog_background.png',
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
          Obx(() {
            if (controller.isLoading.value) {
              return Center(child: CustomLoadingIndicator());
            }

            if (controller.selfRecordResponses.isEmpty) {
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

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: controller.selfRecordResponses.length,
                      itemBuilder: (context, index) {
                        final SelfRecord log =
                            controller.selfRecordResponses[index];
                        final formattedTime =
                            DateFormat('HH:mm').format(log.createdAt);

                        bool showTime = true;
                        if (index > 0) {
                          final previousLog =
                              controller.selfRecordResponses[index - 1];
                          if (DateFormat('yyyy-MM-dd HH:mm')
                                  .format(previousLog.createdAt) ==
                              DateFormat('yyyy-MM-dd HH:mm')
                                  .format(log.createdAt)) {
                            showTime = false;
                          }
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth: 280,
                                  ),
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 26),
                                    decoration: BoxDecoration(
                                      color: Color(0xffD8D8D8).withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 16),
                                        Text(
                                          log.content,
                                          style: TextStyle(
                                            fontFamily: 'Pretendard',
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            color: Color(0xffFFFFFF),
                                          ),
                                          softWrap: true,
                                          overflow: TextOverflow.visible,
                                        ),
                                        SizedBox(height: 16),
                                      ],
                                    ),
                                  ),
                                ),
                                if (showTime)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12, bottom: 12),
                                    child: Text(
                                      formattedTime,
                                      style: TextStyle(
                                        fontFamily: 'Pretendard',
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                        color: Color(0xffD9D9D9),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
