import 'dart:ui';

import 'package:animated_button_bar/animated_button_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nero_app/develop/common/components/calandar_widget.dart';
import 'package:nero_app/develop/common/components/custom_app_bar.dart';
import 'package:nero_app/develop/common/components/custom_divider.dart';
import 'package:nero_app/develop/mypage/controller/mypage_controller.dart';
import 'package:nero_app/develop/mypage/page/mypage_memories_page.dart';
import 'package:nero_app/develop/mypage/page/user_self_record_page.dart';
import 'package:nero_app/develop/mypage/page/user_side_effect_log_page.dart';
import 'package:nero_app/develop/mypage/page/user_survey_log_page.dart';

import '../../memories/controller/memories_controller.dart';
import '../model/menstruation_cycle.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPage createState() => _MyPage();
}

class _MyPage extends State<MyPage> with SingleTickerProviderStateMixin {
  // 기존 컨트롤러들
  final MypageController _monthlyCheckController = Get.put(MypageController());
  final MemoriesController _memoriesController = Get.put(MemoriesController());
  final TextEditingController _textController = TextEditingController();

  // 약 복용 및 부작용 관련 변수들
  final PageController _pageController =
      PageController(initialPage: DateTime.now().month - 1);
  final RxInt currentMonth = DateTime.now().month.obs;
  final RxInt currentYear = DateTime.now().year.obs;
  int currentIndex = DateTime.now().month - 1;
  int previousIndex = DateTime.now().month - 1;

  // 생리 주기 관련 변수들
  final PageController _menstruationPageController =
      PageController(initialPage: DateTime.now().month - 1);
  final RxInt menstruationCurrentMonth = DateTime.now().month.obs;
  final RxInt menstruationCurrentYear = DateTime.now().year.obs;
  int menstruationCurrentIndex = DateTime.now().month - 1;
  int menstruationPreviousIndex = DateTime.now().month - 1;

  final Rx<DateTime> selectedDate = DateTime.now().obs;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _monthlyCheckController.setSelectedType('all');
    _monthlyCheckController.fetchYearlyChecks(currentYear.value);
    _monthlyCheckController.fetchMenstruationCycles(currentYear.value);

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _fadeAnimation =
        Tween<double>(begin: 0, end: 1).animate(_animationController);
    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _menstruationPageController.dispose();
    _animationController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void onPageChanged(int index) {
    setState(() {
      previousIndex = currentIndex;
      currentIndex = index;
      currentMonth.value = index + 1;
    });

    _animationController.reset();
    _animationController.forward();
  }

  void onMenstruationPageChanged(int index) {
    setState(() {
      menstruationPreviousIndex = menstruationCurrentIndex;
      menstruationCurrentIndex = index;
      menstruationCurrentMonth.value = index + 1;
    });
    _monthlyCheckController
        .fetchMenstruationCycles(menstruationCurrentYear.value);

    _animationController.reset();
    _animationController.forward();
  }

  double getAnimationValue(int currentIndex, int widgetIndex, int previousIndex,
      {bool begin = true}) {
    if (widgetIndex == currentIndex) {
      return begin ? 0.9 : 1;
    } else {
      return begin ? 1 : 0.9;
    }
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
            CustomDivider(),
            SizedBox(height: 52),
            _myMemoriesButton(),
            SizedBox(height: 40),
            CustomDivider(),
            SizedBox(height: 32),
            _mypageTitle(
                title: '연간관리',
                content: '언제 약을 먹고, 부작용이 생겼는지\n연간 기록을 모아볼 수 있어요'),
            SizedBox(height: 20),
            _buildAnimatedButtonBar(),
            SizedBox(height: 30),
            _buildPageView(),
            SizedBox(height: 40),
            CustomDivider(),
            SizedBox(height: 32),
            // 생리 주기 섹션 추가
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: _mypageTitle(
                    title: '생리 주기',
                    content: '생리 시작일과 종료일을\n기록하고 관리해보세요',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 32),
                  child: GestureDetector(
                    onTap: () {
                      _showMenstruationInputDialog();
                    },
                    child: Text(
                      '입력하기',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Color(0xffFFADC6),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            _buildMenstruationPageView(),
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
                title: '지난 하루기록', content: '그동안 기록한 하루하루의 몸상태를\n다시 돌아볼 수 있어요'),
            SizedBox(height: 24),
            _buildCustomButton(
              context,
              labelTop: '하루 설문',
              labelBottom: '오늘 하루는 어땠어요?',
              onPressed: () async {
                await _selectDate(context, selectedDate);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserSurveyLogPage(
                      selectedDate: selectedDate.value,
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 16),
            _buildCustomButton(
              context,
              labelTop: '부작용 설문',
              labelBottom: '평소와 다른 증상이 나타났나요?',
              onPressed: () async {
                await _selectDate(context, selectedDate);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserSideEffectLogPage(
                      selectedDate: selectedDate.value,
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 16),
            _buildCustomButton(
              context,
              labelTop: '셀프 기록',
              labelBottom: '오늘 추가로 더 남기고 싶은 말이 있나요?',
              onPressed: () async {
                await _selectDate(context, selectedDate);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserSelfRecordPage(
                      selectedDate: selectedDate.value,
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildMenstruationPageView() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: constraints.maxWidth,
          child: PageView.builder(
            controller: _menstruationPageController,
            itemCount: 12,
            onPageChanged: onMenstruationPageChanged,
            itemBuilder: (context, index) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: TweenAnimationBuilder(
                  duration: const Duration(milliseconds: 20),
                  tween: Tween<double>(
                    begin: getAnimationValue(menstruationCurrentIndex, index,
                        menstruationPreviousIndex),
                    end: getAnimationValue(menstruationCurrentIndex, index,
                        menstruationPreviousIndex,
                        begin: false),
                  ),
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 37),
                        child: _buildMenstruationCardContent(),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildMenstruationCardContent() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF181818).withOpacity(0.1),
            Color(0xFFFEFCFC).withOpacity(0.3),
          ],
          stops: [0, 0.8],
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Card(
        color: Colors.transparent,
        elevation: 0, // No shadow
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              _buildMenstruationMonthYearText(),
              const SizedBox(height: 16),
              _buildDayLabels(),
              const SizedBox(height: 10),
              _buildMenstruationMonthlyMatrix(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenstruationMonthYearText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        menstruationCurrentIndex > 0
            ? FloatingActionButton(
                mini: true,
                elevation: 0,
                backgroundColor: Colors.transparent,
                onPressed: () {
                  _menstruationPageController.previousPage(
                    duration: Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  );
                },
                child: Icon(Icons.arrow_back_ios, color: Colors.white),
              )
            : SizedBox(width: 32),
        Text(
          '${menstruationCurrentYear.value}년 ${menstruationCurrentMonth.value}월',
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        menstruationCurrentIndex < 11
            ? FloatingActionButton(
                mini: true,
                elevation: 0,
                backgroundColor: Colors.transparent,
                onPressed: () {
                  _menstruationPageController.nextPage(
                    duration: Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  );
                },
                child: Icon(Icons.arrow_forward_ios, color: Colors.white),
              )
            : SizedBox(width: 32),
      ],
    );
  }

  Widget _buildMenstruationMonthlyMatrix() {
    return GetBuilder<MypageController>(
      builder: (_) {
        int year = menstruationCurrentYear.value;
        int month = menstruationCurrentMonth.value;
        // 생리 주기 데이터 가져오기
        var cycles = _monthlyCheckController.menstruationCycles;

        // 월의 첫 번째 날과 마지막 날 계산
        DateTime firstDayOfMonth = DateTime(year, month, 1);
        DateTime lastDayOfMonth = DateTime(year, month + 1, 0);
        int totalDays = lastDayOfMonth.day;

        // 달력의 시작 요일 계산 (일요일을 0으로 설정)
        int monthStartIndex = (firstDayOfMonth.weekday % 7);

        // 날짜별 생리 여부 확인
        Set<int> menstruationDays = Set();

        for (var cycle in cycles) {
          DateTime startDate = cycle.startDate;
          DateTime endDate = cycle.endDate;

          // 해당 월과 겹치는 날짜 계산
          DateTime cycleStart = DateTime(year, month, 1);
          DateTime cycleEnd = DateTime(year, month, totalDays);

          DateTime overlapStart =
              startDate.isAfter(cycleStart) ? startDate : cycleStart;
          DateTime overlapEnd = endDate.isBefore(cycleEnd) ? endDate : cycleEnd;

          if (!overlapStart.isAfter(overlapEnd)) {
            for (DateTime date = overlapStart;
                !date.isAfter(overlapEnd);
                date = date.add(Duration(days: 1))) {
              menstruationDays.add(date.day);
            }
          }
        }

        List<Widget> dayWidgets = [];

        // 6x7 매트릭스를 미리 구성
        int totalCells = 6 * 7; // 6줄, 7일씩 42개의 셀

        for (int i = 0; i < totalCells; i++) {
          int day = i - monthStartIndex + 1;

          if (i < monthStartIndex || day > totalDays) {
            // 달력의 빈 칸 (transparent 처리)
            dayWidgets.add(Container(
              margin: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.transparent, // 빈 칸은 투명하게 처리
                borderRadius: BorderRadius.circular(8),
              ),
            ));
          } else {
            bool isMenstruationDay = menstruationDays.contains(day);
            dayWidgets.add(_buildMenstruationDayCell(day, isMenstruationDay));
          }
        }

        return AspectRatio(
          aspectRatio: 7 / 6, // 가로 7, 세로 6의 비율로 고정
          child: GridView.count(
            crossAxisCount: 7,
            childAspectRatio: 1,
            children: dayWidgets,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(8),
          ),
        );
      },
    );
  }

  Widget _buildMenstruationDayCell(int day, bool isMenstruationDay) {
    Color backgroundColor = isMenstruationDay ? Color(0xffFFADC6) : Colors.grey;

    return Container(
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text('$day', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  void _showMenstruationInputDialog() {
    Rx<DateTime> startDate = DateTime.now().obs;
    Rx<DateTime> endDate = DateTime.now().obs;
    TextEditingController notesController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor: Color(0xffD8D8D8).withOpacity(0.3),
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 40),
                        Text(
                          '생리 주기 입력',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 20),
                        _buildDateSelector('시작일', startDate),
                        SizedBox(height: 20),
                        _buildDateSelector('종료일', endDate),
                        SizedBox(height: 20),
                        _buildNotesField(notesController),
                        SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () async {
                            if (endDate.value.isBefore(startDate.value)) {
                              Get.snackbar('오류', '종료일은 시작일보다 빠를 수 없습니다.');
                              return;
                            }
                            MenstruationCycle cycle = MenstruationCycle(
                              owner: 1, // 실제 사용자 ID로 교체해야 합니다.
                              startDate: startDate.value,
                              endDate: endDate.value,
                              notes: notesController.text,
                            );
                            await _monthlyCheckController
                                .createMenstruationCycle(cycle);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff323232),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: 12.0,
                              horizontal: 66.0,
                            ),
                          ),
                          child: Text(
                            '입력하기',
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Color(0xffFFADC6),
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 24,
                  right: 24,
                  child: GestureDetector(
                    onTap: () {
                      Get.back();
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

  Widget _buildDateSelector(String label, Rx<DateTime> date) {
    final RxBool isSelected = false.obs;

    return Obx(() {
      return GestureDetector(
        onTap: () async {
          isSelected.value = true;
          await _selectDate(context, date);
          isSelected.value = false;
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 13, horizontal: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected.value ? Color(0xffFFADC6) : Color(0xffD9D9D9),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('yyyy년 MM월 dd일').format(date.value),
                style: TextStyle(color: Colors.white),
              ),
              Icon(Icons.calendar_today, size: 16, color: Color(0xffD9D9D9)),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildNotesField(TextEditingController controller) {
    return TextField(
      controller: controller,
      style: TextStyle(
        fontSize: 14,
        color: Color(0xffFFFFFF),
        fontFamily: 'Pretendard',
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Color(0xff3C3C3C),
        hintText: '메모를 입력해주세요',
        hintStyle: TextStyle(
          fontSize: 14,
          color: Color(0xff959595),
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w500,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.white.withOpacity(0), width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.white.withOpacity(0), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Color(0xffFFADC6), width: 1),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 13),
      ),
      maxLines: null,
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
            // 맨 앞에 위치한 + 버튼
            Expanded(
              child: Obx(() {
                final memoriesList = _memoriesController.memoriesList;

                if (memoriesList.isEmpty) {
                  return _myMemoriesAdd();
                }

                // 첫 번째 Memories의 items만 가져옴(로그인한 유저의)
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
            contentPadding: EdgeInsets.zero, // 기본 패딩 제거
            content: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40, left: 16, right: 16),
                  // 제목 아래 패딩 추가
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
                      ElevatedButton(
                        onPressed: () {
                          if (_textController.text.isNotEmpty) {
                            _memoriesController.addItem(_textController.text);
                            _textController.clear();
                            Navigator.of(context).pop();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff323232),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: 12.0,
                            horizontal: 66.0,
                          ),
                        ),
                        child: Text(
                          '추가하기',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Color(0xffD0EE17),
                          ),
                        ),
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

  Widget _buildAnimatedButtonBar() {
    return GetBuilder<MypageController>(
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 74),
          child: AnimatedButtonBar(
            backgroundColor: Color(0xff3C3C3C),
            foregroundColor: Color(0xffD0EE17),
            radius: 16.0,
            innerVerticalPadding: 13,
            children: [
              ButtonBarEntry(
                onTap: () {
                  _monthlyCheckController.setSelectedType('all');
                  _monthlyCheckController.update();
                },
                child: Text(
                  '전체',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: _monthlyCheckController.selectedType.value == 'all'
                        ? Color(0xff3C3C3C)
                        : Color(0Xff959595),
                  ),
                ),
              ),
              ButtonBarEntry(
                onTap: () {
                  _monthlyCheckController.setSelectedType('dose');
                  _monthlyCheckController.update();
                },
                child: Text(
                  '약 복용',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: _monthlyCheckController.selectedType.value == 'dose'
                        ? Color(0xff3C3C3C)
                        : Color(0Xff959595),
                  ),
                ),
              ),
              ButtonBarEntry(
                onTap: () {
                  _monthlyCheckController.setSelectedType('side_effect');
                  _monthlyCheckController.update();
                },
                child: Text(
                  '부작용',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: _monthlyCheckController.selectedType.value ==
                            'side_effect'
                        ? Color(0xff3C3C3C)
                        : Color(0Xff959595),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPageView() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: constraints.maxWidth,
          child: PageView.builder(
            controller: _pageController,
            itemCount: 12,
            onPageChanged: onPageChanged,
            itemBuilder: (context, index) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: TweenAnimationBuilder(
                  duration: const Duration(milliseconds: 20),
                  tween: Tween<double>(
                    begin:
                        getAnimationValue(currentIndex, index, previousIndex),
                    end: getAnimationValue(currentIndex, index, previousIndex,
                        begin: false),
                  ),
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 37),
                        child: _buildCardContent(),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildCardContent() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF181818).withOpacity(0.1),
            Color(0xFFFEFCFC).withOpacity(0.3),
          ],
          stops: [0, 0.8],
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Card(
        color: Colors.transparent,
        elevation: 0, // No shadow
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              _buildMonthYearText(),
              const SizedBox(height: 16),
              _buildDayLabels(),
              const SizedBox(height: 10),
              _buildMonthlyMatrix(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMonthYearText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        currentIndex > 0
            ? FloatingActionButton(
                mini: true,
                elevation: 0,
                backgroundColor: Colors.transparent,
                onPressed: () {
                  _pageController.previousPage(
                    duration: Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  );
                },
                child: Icon(Icons.arrow_back_ios, color: Colors.white),
              )
            : SizedBox(width: 32),
        Text(
          '${currentYear.value}년 ${currentMonth.value}월',
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        currentIndex < 11
            ? FloatingActionButton(
                mini: true,
                elevation: 0,
                backgroundColor: Colors.transparent,
                onPressed: () {
                  _pageController.nextPage(
                    duration: Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  );
                },
                child: Icon(Icons.arrow_forward_ios, color: Colors.white),
              )
            : SizedBox(width: 32),
      ],
    );
  }

  Widget _buildDayLabels() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Sun', style: _dayLabelStyle()),
          Text('Mon', style: _dayLabelStyle()),
          Text('Tue', style: _dayLabelStyle()),
          Text('Wed', style: _dayLabelStyle()),
          Text('Thu', style: _dayLabelStyle()),
          Text('Fri', style: _dayLabelStyle()),
          Text('Sat', style: _dayLabelStyle()),
        ],
      ),
    );
  }

  Widget _buildMonthlyMatrix() {
    return GetBuilder<MypageController>(
      builder: (_) {
        final String currentMonthKey =
            '${currentYear.value}-${currentMonth.value}';
        final data = _monthlyCheckController.monthlyCheckCache[currentMonthKey];

        if (data == null) {
          return Center(child: CircularProgressIndicator());
        }

        int totalDays = data.monthEnd;
        int monthStartIndex = data.monthStart;
        List<Widget> dayWidgets = [];

        // 6x7 매트릭스를 미리 구성
        int totalCells = 6 * 7; // 6줄, 7일씩 42개의 셀

        for (int i = 0; i < totalCells; i++) {
          int day = i - monthStartIndex + 1;

          if (i < monthStartIndex || day > totalDays) {
            // 달력의 빈 칸 (transparent 처리)
            dayWidgets.add(Container(
              margin: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.transparent, // 빈 칸은 투명하게 처리
                borderRadius: BorderRadius.circular(8),
              ),
            ));
          } else {
            // 달력의 실제 날짜
            bool hasDose =
                data.doseCheck.containsKey(day) && data.doseCheck[day]!;
            bool hasSideEffect = data.sideEffectCheck.containsKey(day) &&
                data.sideEffectCheck[day]!;

            if (_monthlyCheckController.selectedType.value == 'dose' &&
                hasDose) {
              dayWidgets.add(_buildDayCell(day, hasDose, false));
            } else if (_monthlyCheckController.selectedType.value ==
                    'side_effect' &&
                hasSideEffect) {
              dayWidgets.add(_buildDayCell(day, false, hasSideEffect));
            } else if (_monthlyCheckController.selectedType.value == 'all') {
              dayWidgets
                  .add(_buildDayCellWithShadow(day, hasDose, hasSideEffect));
            } else {
              dayWidgets.add(_buildDayCell(day, false, false));
            }
          }
        }

        return AspectRatio(
          aspectRatio: 7 / 6, // 가로 7, 세로 6의 비율로 고정
          child: GridView.count(
            crossAxisCount: 7,
            childAspectRatio: 1,
            children: dayWidgets,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(8),
          ),
        );
      },
    );
  }

  Widget _buildDayCellWithShadow(int day, bool hasDose, bool hasSideEffect) {
    return Container(
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: hasDose ? Color(0xffD0EE17) : Colors.grey,
        borderRadius: BorderRadius.circular(8),
        boxShadow: hasSideEffect
            ? [
                BoxShadow(
                    color: Color(0xff8B16DB),
                    offset: Offset(0, 0),
                    blurRadius: 4,
                    spreadRadius: 4)
              ]
            : [],
      ),
      child: Center(
        child: Text('$day', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildDayCell(int day, bool hasDose, bool hasSideEffect) {
    Color backgroundColor;
    if (hasDose) {
      backgroundColor = Color(0xffD0EE17);
    } else if (hasSideEffect) {
      backgroundColor = Color(0xff8B16DB);
    } else {
      backgroundColor = Colors.grey;
    }

    return Container(
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text('$day', style: TextStyle(color: Colors.white)),
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

  Future<void> _selectDate(BuildContext context, Rx<DateTime> date) async {
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
                  selectedDate: date,
                  focusedDate: date,
                  selectedColor: Color(0xffFFADC6)),
            ),
          ),
        );
      },
    );

    if (selectedDate != null && selectedDate != date.value) {
      date.value = selectedDate;
    }
  }

  TextStyle _dayLabelStyle() {
    return TextStyle(
      fontFamily: 'Pretendard',
      fontWeight: FontWeight.w500,
      fontSize: 15,
      color: Color(0xffD9D9D9),
    );
  }
}
