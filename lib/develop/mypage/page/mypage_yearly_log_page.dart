import 'package:animated_button_bar/animated_button_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nero_app/develop/common/components/custom_loading_indicator.dart';

import '../../common/components/custom_matrix_pageview_widget.dart';
import '../controller/mypage_controller.dart';

class MypageYearlyLogPage extends StatefulWidget {
  @override
  _MypageYearlyLogPageState createState() => _MypageYearlyLogPageState();
}

class _MypageYearlyLogPageState extends State<MypageYearlyLogPage>
    with SingleTickerProviderStateMixin {
  final MypageController _monthlyCheckController = Get.put(MypageController());

  final PageController _pageController =
      PageController(initialPage: DateTime.now().month - 1);
  final RxInt currentMonth = DateTime.now().month.obs;
  final RxInt currentYear = DateTime.now().year.obs;
  int currentIndex = DateTime.now().month - 1;
  int previousIndex = DateTime.now().month - 1;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _monthlyCheckController.setSelectedType('all');
    _monthlyCheckController.fetchYearlyChecks(currentYear.value);

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
      previousIndex = currentIndex;
      currentIndex = index;
      currentMonth.value = index + 1;
    });

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _mypageTitle(
          title: '연간관리',
          content: '언제 약을 먹고, 부작용이 생겼는지\n연간 기록을 모아볼 수 있어요',
        ),
        SizedBox(height: 20),
        _buildAnimatedButtonBar(),
        SizedBox(height: 30),
        _buildPageView(),
      ],
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
    return CustomMatrixPageviewWidget(
      controller: _pageController,
      itemCount: 12,
      onPageChanged: onPageChanged,
      itemBuilder: (context, index) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: TweenAnimationBuilder(
            duration: const Duration(milliseconds: 20),
            tween: Tween<double>(
              begin: getAnimationValue(currentIndex, index, previousIndex),
              end: getAnimationValue(currentIndex, index, previousIndex,
                  begin: false),
            ),
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: _buildCardContent(),
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
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 15),
              _buildMonthYearText(),
              _buildDayLabels(),
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
                child:
                    Icon(Icons.arrow_back_ios, color: Colors.white, size: 16),
              )
            : SizedBox(width: 32),
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              '${currentYear.value}년 ${currentMonth.value}월',
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
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
                child: Icon(Icons.arrow_forward_ios,
                    color: Colors.white, size: 16),
              )
            : SizedBox(width: 32),
      ],
    );
  }

  Widget _buildDayLabels() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildDayLabel('일'),
          _buildDayLabel('월'),
          _buildDayLabel('화'),
          _buildDayLabel('수'),
          _buildDayLabel('목'),
          _buildDayLabel('금'),
          _buildDayLabel('토'),
        ],
      ),
    );
  }

  Widget _buildDayLabel(String label) {
    return Flexible(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(label, style: _dayLabelStyle()),
      ),
    );
  }

  TextStyle _dayLabelStyle() {
    return TextStyle(
      fontFamily: 'Pretendard',
      fontWeight: FontWeight.w500,
      fontSize: 15,
      color: Color(0xffD9D9D9),
    );
  }

  Widget _buildMonthlyMatrix() {
    return GetBuilder<MypageController>(
      builder: (_) {
        final String currentMonthKey =
            '${currentYear.value}-${currentMonth.value}';
        final data = _monthlyCheckController.monthlyCheckCache[currentMonthKey];

        if (data == null) {
          return Center(child: CustomLoadingIndicator());
        }

        int totalDays = data.monthEnd;
        int monthStartIndex = data.monthStart;
        List<Widget> dayWidgets = [];

        int totalCells = 6 * 7;

        for (int i = 0; i < totalCells; i++) {
          int day = i - monthStartIndex + 1;

          if (i < monthStartIndex || day > totalDays) {
            dayWidgets.add(Container(
              margin: EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
            ));
          } else {
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
            return ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: constraints.maxHeight,
              ),
              child: AspectRatio(
                aspectRatio: 7 / 6,
                child: GridView.count(
                  crossAxisCount: 7,
                  childAspectRatio: 1,
                  children: dayWidgets,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(4),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDayCellWithShadow(int day, bool hasDose, bool hasSideEffect) {
    return Container(
      margin: EdgeInsets.all(2),
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
        child: Text('$day', style: TextStyle(
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w300,
          fontSize: 12,
          color: Colors.white,
        ),),
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
      margin: EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          '$day',
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w300,
            fontSize: 12,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
