import 'dart:ui';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nero_app/develop/common/components/custom_snackbar.dart';
import 'package:nero_app/develop/mypage/page/menstruation_list_page.dart';

import '../../common/components/calandar_widget.dart';
import '../../common/components/custom_matrix_pageview_widget.dart';
import '../controller/mypage_controller.dart';
import '../model/menstruation_cycle.dart';

class MypageMenstruationPage extends StatefulWidget {
  @override
  _MypageMenstruationPageState createState() => _MypageMenstruationPageState();
}

class _MypageMenstruationPageState extends State<MypageMenstruationPage>
    with SingleTickerProviderStateMixin {
  final MypageController _monthlyCheckController = Get.put(MypageController());
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  // 생리 주기 관련 변수들
  static const int menstruationStartYear = 2022;
  static const int menstruationTotalMonths = 100;

  late final int menstruationInitialPage;

  late final PageController _menstruationPageController;

  final RxInt menstruationCurrentMonth = DateTime.now().month.obs;
  final RxInt menstruationCurrentYear = DateTime.now().year.obs;

  late int menstruationCurrentIndex;
  late int menstruationPreviousIndex;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    menstruationInitialPage =
        (DateTime.now().year - menstruationStartYear) * 12 +
            (DateTime.now().month - 1);

    _menstruationPageController = PageController(
      initialPage: menstruationInitialPage,
    );

    menstruationCurrentIndex = menstruationInitialPage;
    menstruationPreviousIndex = menstruationInitialPage;

    _monthlyCheckController
        .fetchMenstruationCycles(menstruationCurrentYear.value);

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
    _menstruationPageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void onMenstruationPageChanged(int index) {
    setState(() {
      menstruationPreviousIndex = menstruationCurrentIndex;
      menstruationCurrentIndex = index;
      menstruationCurrentYear.value = menstruationStartYear + (index ~/ 12);
      menstruationCurrentMonth.value = (index % 12) + 1;
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMenstruationHeader(),
        SizedBox(height: 20),
        _buildMenstruationPageView(),
      ],
    );
  }

  Widget _buildMenstruationHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: SizedBox(
        height: 80, // 원하는 높이로 설정하세요
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '생리 주기',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => MenstruationListPage());
                    },
                    child: Text(
                      '더보기',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Color(0xffFFADC6),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '생리 주기 따로 관리하기 힘드셨죠?\n복약기록과 함께 한눈에 확인해보세요',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Color(0xffD9D9D9),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    height: 30,
                    decoration: BoxDecoration(
                      color: Color(0xff3C3C3C),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Color(0xffFFADC6),
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          _showMenstruationInputDialog();
                        },
                        child: Text(
                          '추가하기',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Color(0xffFFFFFF),
                          ),
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

  Widget _buildMenstruationPageView() {
    analytics.logScreenView(
      screenName: 'MyPageMenstruationCardPage',
      screenClass: 'MyPageMenstruationCardPage',
    );
    return CustomMatrixPageviewWidget(
      controller: _menstruationPageController,
      itemCount: menstruationTotalMonths,
      onPageChanged: onMenstruationPageChanged,
      itemBuilder: (context, index) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: TweenAnimationBuilder(
            duration: const Duration(milliseconds: 20),
            tween: Tween<double>(
              begin: getAnimationValue(
                  menstruationCurrentIndex, index, menstruationPreviousIndex),
              end: getAnimationValue(
                  menstruationCurrentIndex, index, menstruationPreviousIndex,
                  begin: false),
            ),
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: _buildMenstruationCardContent(),
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
              _buildMenstruationMonthYearText(),
              _buildDayLabels(),
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
                child:
                    Icon(Icons.arrow_back_ios, color: Colors.white, size: 16),
              )
            : SizedBox(width: 32),
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              '${menstruationCurrentYear.value}년 ${menstruationCurrentMonth.value}월',
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ),
        menstruationCurrentIndex < menstruationTotalMonths - 1
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
          DateTime overlapEnd =
          endDate.isBefore(cycleEnd) ? endDate : cycleEnd;

          if (!overlapStart.isAfter(overlapEnd)) {
            for (DateTime date = overlapStart;
            !date.isAfter(overlapEnd);
            date = date.add(Duration(days: 1))) {
              menstruationDays.add(date.day);
            }
          }
        }

        List<Widget> dayWidgets = [];

        // 6x7 매트릭스
        int totalCells = 6 * 7; // 6줄, 7일씩 42개의 셀

        for (int i = 0; i < totalCells; i++) {
          int day = i - monthStartIndex + 1;

          if (i < monthStartIndex || day > totalDays) {
            dayWidgets.add(Container(
              margin: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
            ));
          } else {
            bool isMenstruationDay = menstruationDays.contains(day);
            dayWidgets.add(_buildMenstruationDayCell(day, isMenstruationDay));
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

  Widget _buildMenstruationDayCell(int day, bool isMenstruationDay,
      {double size = 40.0, ShapeBorder? shape, Color? color}) {
    Color backgroundColor =
        color ?? (isMenstruationDay ? Color(0xffFFADC6) : Colors.grey);
    ShapeBorder cellShape = shape ??
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        );

    return Container(
      width: size,
      height: size,
      margin: EdgeInsets.all(2),
      decoration: ShapeDecoration(
        color: backgroundColor,
        shape: cellShape,
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
                              CustomSnackbar.show(
                                context: Get.context!,
                                message: '종료일은 시작일보다 빠를 수 없습니다.',
                                isSuccess: false,
                              );
                              return;
                            }
                            MenstruationCycle cycle = MenstruationCycle(
                              owner: 1,
                              startDate: startDate.value,
                              endDate: endDate.value,
                              notes: notesController.text,
                            );
                            await _monthlyCheckController
                                .createMenstruationCycle(cycle);
                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff323232),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 33),
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
          await _selectDate(context, date, {}); // 빈 Set 전달
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
}
