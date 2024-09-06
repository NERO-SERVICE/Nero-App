import 'package:animated_button_bar/animated_button_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nero_app/drf/mypage/controller/drf_montly_check_controller.dart';
import 'package:nero_app/src/common/components/app_font.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrfMonthlyMatrixView extends StatefulWidget {
  @override
  _MonthlyMatrixViewState createState() => _MonthlyMatrixViewState();
}

class _MonthlyMatrixViewState extends State<DrfMonthlyMatrixView>
    with SingleTickerProviderStateMixin {
  final DrfMonthlyCheckController _monthlyCheckController =
      Get.put(DrfMonthlyCheckController());
  final PageController _pageController =
      PageController(initialPage: DateTime.now().month - 1);
  final RxInt currentMonth = DateTime.now().month.obs;
  final RxInt currentYear = DateTime.now().year.obs;
  int currentIndex = -1, previousIndex = 0;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
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

    // Trigger the fade animation on page change
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
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 55),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '연간 관리',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 34),
                  _buildAnimatedButtonBar(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  _buildPageView(),
                ],
              ),
            ),
            SizedBox(height: 33),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                '월간 레포트',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 33),
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    'assets/images/to_be_continued.png',
                    fit: BoxFit.cover,
                  ),
                  Container(// Optional: Dark overlay for better contrast
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '추후 공개됩니다',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leadingWidth: Get.width * 0.6,
      leading: Padding(
        padding: const EdgeInsets.only(left: 25),
        child: Row(children: [
          const AppFont(
            '마이페이지',
            fontWeight: FontWeight.bold,
            size: 20,
            color: Colors.white,
          ),
          const SizedBox(width: 10),
        ]),
      ),
      actions: [
        SvgPicture.asset('assets/svg/icons/search.svg'),
        const SizedBox(width: 15),
        SvgPicture.asset('assets/svg/icons/list.svg'),
        const SizedBox(width: 15),
        IconButton(
          icon: Icon(Icons.logout, color: Colors.white),
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.remove('accessToken');
            await prefs.remove('refreshToken');
            Navigator.of(context).pushReplacementNamed('/login');
          },
        ),
      ],
    );
  }

  Widget _buildAnimatedButtonBar() {
    return GetBuilder<DrfMonthlyCheckController>(
      builder: (_) {
        return AnimatedButtonBar(
          backgroundColor: Color(0xffD9D9D9).withOpacity(0.5),
          foregroundColor: Color(0xffD0EE17),
          radius: 16.0,
          innerVerticalPadding: 16,
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
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: _monthlyCheckController.selectedType.value == 'all'
                      ? Colors.black // Selected color
                      : Colors.white, // Unselected color
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
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: _monthlyCheckController.selectedType.value == 'dose'
                      ? Colors.black
                      : Colors.white,
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
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: _monthlyCheckController.selectedType.value == 'side_effect'
                      ? Colors.black
                      : Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPageView() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: constraints.maxWidth, // 너비에 기반하여 높이 유동적으로 조정
          child: PageView.builder(
            controller: _pageController,
            itemCount: 12,
            onPageChanged: onPageChanged,
            itemBuilder: (context, index) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: TweenAnimationBuilder(
                  duration: const Duration(milliseconds: 400),
                  tween: Tween<double>(
                    begin: getAnimationValue(currentIndex, index, previousIndex),
                    end: getAnimationValue(currentIndex, index, previousIndex,
                        begin: false),
                  ),
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
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
        borderRadius: BorderRadius.circular(15), // Rounded corners
      ),
      child: Card(
        color: Colors.transparent, // Transparent to show gradient
        elevation: 0, // No shadow
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // Rounded corners
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
    return GetBuilder<DrfMonthlyCheckController>(
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
            bool hasDose = data.doseCheck.containsKey(day) && data.doseCheck[day]!;
            bool hasSideEffect = data.sideEffectCheck.containsKey(day) &&
                data.sideEffectCheck[day]!;

            if (_monthlyCheckController.selectedType.value == 'dose' && hasDose) {
              dayWidgets.add(_buildDayCell(day, hasDose, false));
            } else if (_monthlyCheckController.selectedType.value ==
                'side_effect' &&
                hasSideEffect) {
              dayWidgets.add(_buildDayCell(day, false, hasSideEffect));
            } else if (_monthlyCheckController.selectedType.value == 'all') {
              dayWidgets.add(_buildDayCellWithShadow(day, hasDose, hasSideEffect));
            } else {
              dayWidgets.add(_buildDayCell(day, false, false));
            }
          }
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            double cellWidth = (constraints.maxWidth - 32) / 7; // 7열 기반의 너비 계산
            double cellHeight = cellWidth; // 셀의 가로와 세로 비율 동일하게 설정

            return GridView.count(
              crossAxisCount: 7, // 7열 고정
              childAspectRatio: 1, // 셀의 가로 세로 비율 동일하게 유지
              children: dayWidgets,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(8), // 외부 패딩 적용
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

  TextStyle _dayLabelStyle() {
    return TextStyle(
      fontFamily: 'Pretendard',
      fontWeight: FontWeight.w500,
      fontSize: 15,
      color: Color(0xffD9D9D9),
    );
  }
}
