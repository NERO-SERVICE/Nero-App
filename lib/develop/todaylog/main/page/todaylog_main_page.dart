import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nero_app/develop/common/components/custom_app_bar.dart';
import 'package:nero_app/develop/common/components/custom_divider.dart';
import 'package:nero_app/develop/todaylog/clinic/page/clinic_detail_page.dart';
import 'package:nero_app/develop/todaylog/main/page/daily_drug_widget.dart';
import 'package:nero_app/develop/todaylog/recall/page/self_record_page.dart';
import 'package:nero_app/develop/todaylog/recall/page/side_effect_page.dart';
import 'package:nero_app/develop/todaylog/recall/page/survey_page.dart';

import '../../../common/components/custom_loading_indicator.dart';
import '../../clinic/controller/clinic_controller.dart';
import '../../clinic/write/page/clinic_write_page.dart';
import '../enum/month_image.dart';

class TodaylogMainPage extends StatefulWidget {
  @override
  State<TodaylogMainPage> createState() => _TodayLogMainPageState();
}

class _TodayLogMainPageState extends State<TodaylogMainPage> {
  final ClinicController clinicController = Get.put(ClinicController());
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  Widget build(BuildContext context) {
    analytics.logScreenView(
      screenName: 'TodaylogMainPage',
      screenClass: 'TodaylogMainPage',
    );
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        title: '하루 기록',
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: kToolbarHeight + 56),
            SizedBox(height: 18),
            _todaylogTitle(
              title: '데일리 복용관리',
              content:
                  '매일 복약 여부를 체크하는 곳이에요.\n오늘 복용한 약물만 체크해주세요',
            ),
            SizedBox(height: 24),
            Obx(() {
              if (clinicController.isLoading.value) {
                return Center(child: CustomLoadingIndicator());
              }

              if (clinicController.errorMessage.isNotEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: Color(0xff323232),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '기록이 비어있습니다.\n진료기록을 입력해주세요',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Color(0xffD9D9D9).withOpacity(0.5),
                      ),
                    ),
                  ),
                );
              }

              if (clinicController.clinics.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: Color(0xff323232),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '기록이 비어있습니다.\n진료기록을 입력해주세요',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Color(0xffD9D9D9).withOpacity(0.5),
                      ),
                    ),
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: DailyDrugWidget(
                  recentDay: clinicController.clinics.first.recentDay,
                ),
              );
            }),
            SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '진료기록 작성',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      _clinicWriteWidget(context),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    '새로 처방받은 약이 있나요? 여기서 등록해요',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Color(0xffD9D9D9),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            CustomDivider(),
            SizedBox(height: 32),
            _todaylogTitle(
              title: '하루 돌아보기',
              content: '오늘 하루는 평소와 다른 점이 있었나요?\n내가 느낀 나의 상태를 직접 기록해보아요',
            ),
            SizedBox(height: 25),
            _buildCustomButton(
              context,
              labelTop: '하루 설문',
              labelBottom: '검증된 설문을 통해 내 마음을 확인해 보세요',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SurveyPage()),
                );
              },
            ),
            SizedBox(height: 16),
            _buildCustomButton(
              context,
              labelTop: '부작용 설문',
              labelBottom: '평소와 다른 증상이 나타났나요?',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SideEffectPage()),
                );
              },
            ),
            SizedBox(height: 16),
            _buildCustomButton(
              context,
              labelTop: '셀프 기록',
              labelBottom: '오늘 하루를 보내며 기억하고 싶은 일이 있었나요?',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SelfRecordPage()),
                );
              },
            ),
            SizedBox(height: 50),
            CustomDivider(),
            SizedBox(height: 32),
            _todaylogTitle(
              title: '과거 진료기록',
              content: '그동안 병원에서 받은 진료 기록과\n처방받은 이력을 모아볼 수 있는 곳이에요',
            ),
            SizedBox(height: 32),
            Obx(() {
              if (clinicController.isLoading.value) {
                return Center(child: CustomLoadingIndicator());
              }

              if (clinicController.errorMessage.isNotEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: Color(0xff323232),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '기록이 비어있습니다.\n진료기록을 입력해주세요',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Color(0xffD9D9D9).withOpacity(0.5),
                      ),
                    ),
                  ),
                );
              }

              if (clinicController.clinics.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: Color(0xff323232),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '기록이 비어있습니다.\n진료기록을 입력해주세요',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Color(0xffD9D9D9).withOpacity(0.5),
                      ),
                    ),
                  ),
                );
              }

              return _clinicListWidget();
            }),
            SizedBox(height: 36),
          ],
        ),
      ),
    );
  }

  Widget _todaylogTitle({required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 16),
          Text(
            content,
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Color(0xffD9D9D9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomButton(
    BuildContext context, {
    required String labelTop,
    required String labelBottom,
    required VoidCallback onPressed,
    EdgeInsetsGeometry padding =
        const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: padding,
          backgroundColor: Color(0xff323232),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    labelTop,
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Color(0xffFFFFFF),
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    labelBottom,
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: Color(0xffD9D9D9),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Color(0xffD0EE17),
            ),
          ],
        ),
      ),
    );
  }

  Widget _clinicWriteWidget(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      height: 30,
      decoration: BoxDecoration(
        color: Color(0xff3C3C3C),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Color(0xffD0EE17),
          width: 1,
        ),
      ),
      child: Center(
        child: GestureDetector(
          onTap: () {
            Get.to(() => ClinicWritePage());
          },
          child: Text(
            '작성하기',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Color(0xffFFFFFF),
            ),
          ),
        ),
      ),
    );
  }


  Widget _clinicListWidget() {
    final double containerHeight = 150;
    final double itemSpacing = 16;

    return Container(
      height: containerHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: clinicController.clinics.length,
        padding: EdgeInsets.only(left: 32),
        itemBuilder: (context, index) {
          final clinic = clinicController.clinics[index];
          final clinicDate = clinic.recentDay;
          final monthImage = MonthImage.fromDateTime(clinicDate);

          final formattedDate = DateFormat('yyyy-MM-dd').format(clinicDate);

          return Padding(
            padding: EdgeInsets.only(right: itemSpacing),
            child: GestureDetector(
              onTap: () {
                Get.to(() => ClinicDetailPage(clinicId: clinic.clinicId));
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: containerHeight,
                    decoration: BoxDecoration(
                      color: Color(0xff323232),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          monthImage.assetPath,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            formattedDate,
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 15),
                          Text(
                            '진료기록',
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Color(0xffD9D9D9),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
