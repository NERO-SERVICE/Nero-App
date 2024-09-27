import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nero_app/develop/mypage/controller/mypage_controller.dart';
import 'package:nero_app/develop/todaylog/recall/model/self_record.dart';

import '../../common/components/custom_loading_indicator.dart';

class UserSelfRecordPage extends StatelessWidget {
  final DateTime selectedDate;

  UserSelfRecordPage({required this.selectedDate});

  @override
  Widget build(BuildContext context) {
    final MypageController controller = Get.put(MypageController());

    controller.fetchPreviousSelfRecordAnswers(selectedDate);

    return Scaffold(
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
                    fontSize: 16,
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
                    SizedBox(height: kToolbarHeight + 29),
                    Text(
                      '셀프 기록',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w600,
                        fontSize: 25,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 13),
                    Text(
                      '${selectedDate.year}년 ${selectedDate.month}월 ${selectedDate.day}일의 기록입니다',
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
                      itemCount: controller.selfRecordResponses.length,
                      itemBuilder: (context, index) {
                        final SelfRecord log =
                            controller.selfRecordResponses[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              log.content,
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(height: 8),
                            Text(
                              log.createdAt.toString(),
                              style: TextStyle(color: Colors.white54),
                            ),
                            SizedBox(height: 20),
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
