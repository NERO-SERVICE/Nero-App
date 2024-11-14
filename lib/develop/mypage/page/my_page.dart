import 'dart:ui';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nero_app/develop/common/components/custom_app_bar.dart';
import 'package:nero_app/develop/common/components/custom_divider.dart';
import 'package:nero_app/develop/community/pages/community_liked_posts_page.dart';
import 'package:nero_app/develop/mypage/page/mypage_memories_page.dart';
import 'package:nero_app/develop/mypage/page/mypage_menstruation_page.dart';
import 'package:nero_app/develop/mypage/page/mypage_yearly_log_page.dart';
import 'package:nero_app/develop/mypage/page/user_profile_update_page.dart';
import 'package:nero_app/develop/mypage/page/user_self_record_page.dart';
import 'package:nero_app/develop/mypage/page/user_side_effect_log_page.dart';
import 'package:nero_app/develop/mypage/page/user_survey_log_page.dart';

import '../../common/components/calandar_widget.dart';
import '../../common/components/custom_complete_button.dart';
import '../../memories/controller/memories_controller.dart';
import '../controller/mypage_controller.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPage createState() => _MyPage();
}

class _MyPage extends State<MyPage> {
  final MypageController _monthlyCheckController = Get.put(MypageController());
  final MemoriesController _memoriesController = Get.put(MemoriesController());
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final TextEditingController _textController = TextEditingController();
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<DateTime?> _selectDate(
      BuildContext context,
      DateTime initialDate,
      Set<DateTime> recordedDates,
      ) async {
    final selectedDate = await showModalBottomSheet<DateTime>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CalendarWidget(
                    initialSelectedDate: initialDate,
                    initialFocusedDate: initialDate,
                    markedDates: recordedDates,
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
    return selectedDate;
  }

  Widget _mypageTitle({required String title, required String content}) {
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

  Widget _myMemoriesButton() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '챙길거리',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Color(0xffFFFFFF),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.to(() => MypageMemoriesPage());
                },
                child: Text(
                  '더보기',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Color(0xffD0EE17),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: Obx(() {
                final memoriesList = _memoriesController.memoriesList;

                if (memoriesList.isEmpty) {
                  return _myMemoriesAdd();
                }

                final items = memoriesList[0].items ?? [];

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      SizedBox(width: 32),
                      _myMemoriesAdd(),
                      SizedBox(width: 8),
                      ...items.map((item) {
                        return Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 28),
                          height: 40,
                          decoration: BoxDecoration(
                            color: Color(0xffD0EE17).withOpacity(0.5),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Color(0xffD0EE17),
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              item,
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Color(0xffFFFFFF),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ],
    );
  }

  void _showAddMemoryDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor: Color(0xffD8D8D8).withOpacity(0.3),
            contentPadding: EdgeInsets.zero,
            content: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40, left: 16, right: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "챙길거리 추가",
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        cursorColor: Color(0xffD9D9D9),
                        controller: _textController,
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xffFFFFFF),
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xff3C3C3C),
                          hintText: '챙길거리를 입력해주세요',
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: Color(0xff959595),
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w500,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                                color: Colors.white.withOpacity(0), width: 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                                color: Colors.white.withOpacity(0), width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide:
                                BorderSide(color: Color(0xffD0EE17), width: 1),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 13),
                        ),
                      ),
                      const SizedBox(height: 20),
                      CustomCompleteButton(
                        onPressed: () {
                          if (_textController.text.isNotEmpty) {
                            _memoriesController.addItem(_textController.text);
                            _textController.clear();
                            Navigator.of(context).pop();
                          }
                        },
                        text: '추가하기',
                        isEnabled: true,
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _myMemoriesAdd() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showAddMemoryDialog();
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        height: 40,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Color(0xffD0EE17),
            width: 1,
          ),
        ),
        child: Center(
          child: SvgPicture.asset('assets/develop/memories-plus.svg'),
        ),
      ),
    );
  }

  Widget _mypageUserInfo() {
    return Obx(() {
      final nickname = _monthlyCheckController.userInfo.value.nickname;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "안녕하세요",
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "${nickname} 님",
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () async {
                await Get.to(() => UserProfileUpdatePage());
                _monthlyCheckController.fetchUserInfo(); // 돌아온 후 데이터 새로고침
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                height: 30,
                decoration: BoxDecoration(
                  color: Color(0xff3C3C3C),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    '프로필 설정',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Color(0xffFFFFFF),
                    ),
                  ),
                ),
              ),
            ),
          ]
        ),
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    analytics.logScreenView(
      screenName: 'MyPage',
      screenClass: 'MyPage',
    );
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(title: '마이페이지'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: kToolbarHeight + 80),
            _mypageUserInfo(),
            SizedBox(height: 40),
            _myMemoriesButton(),
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '좋아요 한 커뮤니티 글',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Color(0xffFFFFFF),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => CommunityLikedPostsPage());
                    },
                    child: Text(
                      '더보기',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Color(0xffD0EE17),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            CustomDivider(),
            SizedBox(height: 32),
            MypageYearlyLogPage(),
            SizedBox(height: 40),
            CustomDivider(),
            SizedBox(height: 32),
            MypageMenstruationPage(),
            SizedBox(height: 40),
            CustomDivider(),
            SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                '월간 레포트',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Color(0xffFFFFFF),
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    'assets/images/to_be_continued.png',
                    fit: BoxFit.cover,
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '추후 공개됩니다',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            CustomDivider(),
            SizedBox(height: 32),
            _mypageTitle(
              title: '과거 하루기록',
              content: '지난주에 내가 어땠더라?\n여기서 찾아보세요',
            ),
            SizedBox(height: 24),
            _buildCustomButton(
              context,
              labelTop: '하루 설문',
              labelBottom: '검증된 설문을 통해 내 마음을 확인해 보세요',
              onPressed: () async {
                // Fetch the recorded dates
                await _monthlyCheckController.fetchSurveyRecordedDates(selectedDate.value.year);
                final date = await _selectDate(
                  context,
                  selectedDate.value,
                  _monthlyCheckController.surveyRecordedDates, // Highlight recorded dates
                );
                if (date != null) {
                  // Navigate to the survey log page if a valid date is selected
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserSurveyLogPage(
                        selectedDate: date,
                      ),
                    ),
                  );
                }
              },
            ),
            SizedBox(height: 10),
            _buildCustomButton(
              context,
              labelTop: '부작용 설문',
              labelBottom: '평소와 다른 증상이 나타났나요?',
              onPressed: () async {
                // Fetch the recorded dates
                await _monthlyCheckController.fetchSideEffectRecordedDates(selectedDate.value.year);
                final date = await _selectDate(
                  context,
                  selectedDate.value,
                  _monthlyCheckController.sideEffectRecordedDates, // Highlight recorded dates
                );
                if (date != null) {
                  // Navigate to the side effect log page if a valid date is selected
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserSideEffectLogPage(
                        selectedDate: date,
                      ),
                    ),
                  );
                }
              },
            ),
            SizedBox(height: 10),
            _buildCustomButton(
              context,
              labelTop: '셀프 기록',
              labelBottom: '오늘 하루를 보내며 기억하고 싶은 일이 있었나요?',
              onPressed: () async {
                // Fetch the recorded dates
                await _monthlyCheckController.fetchSelfRecordRecordedDates(selectedDate.value.year);
                final date = await _selectDate(
                  context,
                  selectedDate.value,
                  _monthlyCheckController.selfRecordRecordedDates, // Highlight recorded dates
                );
                if (date != null) {
                  // Navigate to the self record log page if a valid date is selected
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserSelfRecordPage(
                        selectedDate: date,
                      ),
                    ),
                  );
                }
              },
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
