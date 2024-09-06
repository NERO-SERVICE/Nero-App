import 'package:animated_button_bar/animated_button_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nero_app/drf/mypage/controller/drf_montly_check_controller.dart';

class DrfMonthlyMatrixView extends StatefulWidget {
  @override
  _MonthlyMatrixViewState createState() => _MonthlyMatrixViewState();
}

class _MonthlyMatrixViewState extends State<DrfMonthlyMatrixView> {
  final DrfMonthlyCheckController _monthlyCheckController =
      Get.put(DrfMonthlyCheckController());
  final PageController _pageController =
      PageController(initialPage: DateTime.now().month - 1);
  final RxInt currentMonth = DateTime.now().month.obs;
  final RxInt currentYear = DateTime.now().year.obs;

  @override
  void initState() {
    super.initState();
    _monthlyCheckController.preloadMonthlyData(
        currentYear.value, currentMonth.value);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void onPageChanged(int index) {
    setState(() {
      currentMonth.value = index + 1;
    });
    _monthlyCheckController.preloadMonthlyData(
        currentYear.value, currentMonth.value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('연간 관리')),
      body: Column(
        children: [
          GetBuilder<DrfMonthlyCheckController>(
            builder: (_) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: AnimatedButtonBar(
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
                      child: Text('전체'),
                    ),
                    ButtonBarEntry(
                      onTap: () {
                        _monthlyCheckController.setSelectedType('dose');
                        _monthlyCheckController.preloadMonthlyData(
                            currentYear.value, currentMonth.value);
                        _monthlyCheckController.update();
                      },
                      child: Text('약 복용'),
                    ),
                    ButtonBarEntry(
                      onTap: () {
                        _monthlyCheckController.setSelectedType('side_effect');
                        _monthlyCheckController.preloadMonthlyData(
                            currentYear.value, currentMonth.value);
                        _monthlyCheckController.update();
                      },
                      child: Text('부작용'),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Column(
              children: [
                Obx(() {
                  return Text(
                    '${currentYear.value}년 ${currentMonth.value}월',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Sun',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: Color(0xffD9D9D9),
                        ),
                      ),
                      Text(
                        'Mon',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: Color(0xffD9D9D9),
                        ),
                      ),
                      Text(
                        'Tue',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: Color(0xffD9D9D9),
                        ),
                      ),
                      Text(
                        'Wed',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: Color(0xffD9D9D9),
                        ),
                      ),
                      Text(
                        'Thu',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: Color(0xffD9D9D9),
                        ),
                      ),
                      Text(
                        'Fri',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: Color(0xffD9D9D9),
                        ),
                      ),
                      Text(
                        'Sat',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: Color(0xffD9D9D9),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: 12,
                    onPageChanged: onPageChanged,
                    itemBuilder: (context, index) {
                      return GetBuilder<DrfMonthlyCheckController>(
                        builder: (_) {
                          return Column(
                            children: [
                              Expanded(
                                child: _buildMonthlyMatrix(),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
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

        for (int i = 0; i < monthStartIndex; i++) {
          dayWidgets.add(Container());
        }

        for (int day = 1; day <= totalDays; day++) {
          bool hasDose =
              data.doseCheck.containsKey(day) && data.doseCheck[day]!;
          bool hasSideEffect = data.sideEffectCheck.containsKey(day) &&
              data.sideEffectCheck[day]!;

          if (_monthlyCheckController.selectedType.value == 'dose' && hasDose) {
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

        return GridView.count(
          crossAxisCount: 7,
          children: dayWidgets,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
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
                  color: Color(0xff8B16DB), // 그림자 색상
                  offset: Offset(0, 0), // 그림자의 x, y 좌표
                  blurRadius: 4, // 흐림 정도
                  spreadRadius: 4, // 그림자의 확산 정도
                ),
              ]
            : [],
      ),
      child: Center(
        child: Text(
          '$day',
          style: TextStyle(color: Colors.white),
        ),
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
        child: Text(
          '$day',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
