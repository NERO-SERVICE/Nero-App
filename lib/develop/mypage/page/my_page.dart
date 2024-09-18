import 'dart:ui';

import 'package:animated_button_bar/animated_button_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nero_app/develop/common/components/calandar_widget.dart';
import 'package:nero_app/develop/common/components/custom_app_bar.dart';
import 'package:nero_app/develop/common/components/custom_divider.dart';
import 'package:nero_app/develop/mypage/controller/mypage_controller.dart';
import 'package:nero_app/develop/mypage/page/user_self_record_page.dart';
import 'package:nero_app/develop/mypage/page/user_side_effect_log_page.dart';
import 'package:nero_app/develop/mypage/page/user_survey_log_page.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPage createState() => _MyPage();
}

class _MyPage extends State<MyPage> with SingleTickerProviderStateMixin {
  final MypageController _monthlyCheckController = Get.put(MypageController());
  final PageController _pageController =
      PageController(initialPage: DateTime.now().month - 1);
  final RxInt currentMonth = DateTime.now().month.obs;
  final RxInt currentYear = DateTime.now().year.obs;
  int currentIndex = -1, previousIndex = 0;
  final Rx<DateTime> selectedDate = DateTime.now().obs;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _monthlyCheckController.setSelectedType('all');

    _monthlyCheckController.preloadMonthlyData(
        currentYear.value, currentMonth.value);

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
    _animationController.dispose();
    super.dispose();
  }

  void onPageChanged(int index) {
    setState(() {
      if (currentIndex != -1) {
        previousIndex = currentIndex;
      }
      currentIndex = index;
      currentMonth.value = index + 1;
    });
    _monthlyCheckController.preloadMonthlyData(
        currentYear.value, currentMonth.value);

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
                  _monthlyCheckController.preloadMonthlyData(
                      currentYear.value, currentMonth.value);
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
                  _monthlyCheckController.preloadMonthlyData(
                      currentYear.value, currentMonth.value);
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
                  _monthlyCheckController.preloadMonthlyData(
                      currentYear.value, currentMonth.value);
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
                        child: IntrinsicHeight(
                          // 자식 높이 유동적으로 조절
                          child: _buildCardContent(),
                        ),
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
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.bold,
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

        return LayoutBuilder(
          builder: (context, constraints) {
            return GridView.count(
              crossAxisCount: 7,
              // 7열 고정
              childAspectRatio: 1,
              // 셀의 가로 세로 비율 동일하게 유지
              children: dayWidgets,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(8),
            );
          },
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

// 날짜 선택 기능
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

  TextStyle _dayLabelStyle() {
    return TextStyle(
      fontFamily: 'Pretendard',
      fontWeight: FontWeight.w500,
      fontSize: 15,
      color: Color(0xffD9D9D9),
    );
  }
}
