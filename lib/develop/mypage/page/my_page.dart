import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nero_app/develop/common/components/custom_app_bar.dart';
import 'package:nero_app/develop/common/components/custom_divider.dart';
import 'package:nero_app/develop/mypage/page/mypage_memories_page.dart';
import 'package:nero_app/develop/mypage/page/mypage_menstruation_page.dart';
import 'package:nero_app/develop/mypage/page/mypage_yearly_log_page.dart';
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

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, Rx<DateTime> date,
      Set<DateTime> recordedDates) async {
    final selectedDate = await showModalBottomSheet<DateTime>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              padding: EdgeInsets.all(16),
              height: 400,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: CalendarWidget(
                initialSelectedDate: date.value,
                initialFocusedDate: date.value,
                markedDates: recordedDates,
              ),
            ),
          ),
        );
      },
    );

    if (selectedDate != null && selectedDate != date.value) {
      date.value = selectedDate;
    }
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
                          hintText: '준비물을 입력해주세요(10자이내)',
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

  Future<bool> _showConfirmationDialog(
      String content, String confirm, Color dialogColor) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor: Color(0xffD8D8D8).withOpacity(0.3),
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      content,
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Color(0xffFFFFFF),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                            color: Color(0xffD8D8D8).withOpacity(0.3),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(16),
                            ),
                          ),
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            child: Center(
                              child: Text(
                                "취소",
                                style: TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                            color: dialogColor,
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(16),
                            ),
                          ),
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                            child: Center(
                              child: Text(
                                confirm,
                                style: TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(title: '마이페이지'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: kToolbarHeight + 56),
            _myMemoriesButton(),
            SizedBox(height: 40),
            CustomDivider(),
            SizedBox(height: 32),
            // 연간관리 페이지 호출
            MypageYearlyLogPage(),
            SizedBox(height: 40),
            CustomDivider(),
            SizedBox(height: 32),
            // 생리주기 페이지 호출
            MypageMenstruationPage(),
            SizedBox(height: 40),
            CustomDivider(),
            SizedBox(height: 32),
            _mypageTitle(
              title: '지난 하루기록',
              content: '그동안 기록한 하루하루의 몸상태를\n다시 돌아볼 수 있어요',
            ),
            SizedBox(height: 24),
            _buildCustomButton(
              context,
              labelTop: '하루 설문',
              labelBottom: '오늘 하루는 어땠어요?',
              onPressed: () async {
                await _monthlyCheckController
                    .fetchSurveyRecordedDates(selectedDate.value.year);
                await _selectDate(
                  context,
                  selectedDate,
                  _monthlyCheckController.surveyRecordedDates,
                );
                if (selectedDate.value != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserSurveyLogPage(
                        selectedDate: selectedDate.value,
                      ),
                    ),
                  );
                }
              },
            ),
            SizedBox(height: 16),
            _buildCustomButton(
              context,
              labelTop: '부작용 설문',
              labelBottom: '평소와 다른 증상이 나타났나요?',
              onPressed: () async {
                await _monthlyCheckController
                    .fetchSideEffectRecordedDates(selectedDate.value.year);
                await _selectDate(
                  context,
                  selectedDate,
                  _monthlyCheckController.sideEffectRecordedDates,
                );
                if (selectedDate.value != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserSideEffectLogPage(
                        selectedDate: selectedDate.value,
                      ),
                    ),
                  );
                }
              },
            ),
            SizedBox(height: 16),
            _buildCustomButton(
              context,
              labelTop: '셀프 기록',
              labelBottom: '오늘 추가로 더 남기고 싶은 말이 있나요?',
              onPressed: () async {
                await _monthlyCheckController
                    .fetchSelfRecordRecordedDates(selectedDate.value.year);
                await _selectDate(
                  context,
                  selectedDate,
                  _monthlyCheckController.selfRecordRecordedDates,
                );
                if (selectedDate.value != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserSelfRecordPage(
                        selectedDate: selectedDate.value,
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
