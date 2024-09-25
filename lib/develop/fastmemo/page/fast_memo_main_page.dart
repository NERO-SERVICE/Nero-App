import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nero_app/background_layout.dart';
import 'package:nero_app/develop/common/components/custom_app_bar.dart';
import 'package:nero_app/develop/fastmemo/controller/fastmemo_controller.dart';
import 'package:nero_app/develop/fastmemo/repository/fastmemo_repository.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../common/components/custom_divider.dart';
import 'fast_memo_detail_page.dart';

class FastMemoMainPage extends StatefulWidget {
  @override
  _FastMemoMainPageState createState() => _FastMemoMainPageState();
}

class _FastMemoMainPageState extends State<FastMemoMainPage> {
  final FastmemoController controller = Get.put(FastmemoController());
  final FastmemoRepository repository = Get.find<FastmemoRepository>();
  final Map<int, bool> _selectedMap = {}; // 메모 선택 상태 관리

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(title: '빠른 메모'),
      body: BackgroundLayout(
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(), // 기본적으로 수직 스크롤
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: kToolbarHeight + 56),
              SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  '날짜별로 모아 달력에 저장하는 빠른 메모,\n까먹을 것 같은 모든 정보들을\n빠른 메모에 적어주세요!',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Color(0xffD9D9D9),
                  ),
                ),
              ),
              SizedBox(height: 60),
              _fastCalendar(),
              SizedBox(height: 50),
              CustomDivider(),
              SizedBox(height: 24),
              _uncheckedMemo(),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _fastCalendar() {
    return Obx(
          () => TableCalendar(
        firstDay: DateTime.utc(2010, 10, 16),
        lastDay: DateTime.utc(2030, 3, 14),
        focusedDay: controller.focusedDay.value,
        locale: 'ko_KR',
        availableGestures: AvailableGestures.horizontalSwipe,
        selectedDayPredicate: (day) {
          return isSameDay(controller.selectedDay.value, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          controller.onDaySelected(selectedDay, focusedDay);
          repository.setSelectedDate(selectedDay);
        },
        onPageChanged: (focusedDay) {
          controller.onPageChanged(focusedDay);
          repository.fetchMemoDates(focusedDay.year);
        },
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
          ),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          leftChevronIcon: Icon(
            Icons.chevron_left,
            color: Colors.white,
          ),
          rightChevronIcon: Icon(
            Icons.chevron_right,
            color: Colors.white,
          ),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: TextStyle(color: Color(0xff6D7179)),
          weekendStyle: TextStyle(color: Color(0xff6D7179)),
        ),
        daysOfWeekHeight: 60,
        calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(
            color: Colors.grey,
            shape: BoxShape.circle,
          ),
          selectedDecoration: BoxDecoration(
            color: Color(0xffD0EE17),
            shape: BoxShape.circle,
          ),
          outsideDaysVisible: false,
          defaultDecoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          weekendDecoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          disabledDecoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          todayTextStyle: TextStyle(
            color: Colors.white,
          ),
          selectedTextStyle: TextStyle(
            color: Colors.white,
          ),
          defaultTextStyle: TextStyle(
            color: Colors.grey,
          ),
          weekendTextStyle: TextStyle(
            color: Color(0xff6D7179),
          ),
        ),
        calendarBuilders: CalendarBuilders(
          // 기본 날짜 빌더
          defaultBuilder: (context, date, focusedDay) {
            return _buildDayCell(date);
          },
          // 선택된 날짜 빌더
          selectedBuilder: (context, date, focusedDay) {
            return _buildDayCell(date, isSelected: true);
          },
          // 오늘 날짜 빌더
          todayBuilder: (context, date, focusedDay) {
            return _buildDayCell(date, isToday: true);
          },
          // 외부 날짜 빌더 (월 외 날짜)
          outsideBuilder: (context, date, focusedDay) {
            return Container(); // 빈 컨테이너로 표시
          },
        ),
      ),
    );
  }

  Widget _buildDayCell(DateTime date, {bool isSelected = false, bool isToday = false}) {
    bool hasMemo = repository.memoDates.contains(DateTime(date.year, date.month, date.day));

    // 기본 텍스트 스타일
    TextStyle textStyle = TextStyle(
      color: isSelected
          ? Colors.white
          : isToday
          ? Colors.white
          : (date.weekday == DateTime.saturday || date.weekday == DateTime.sunday)
          ? Color(0xff6D7179)
          : Colors.grey,
      fontWeight: FontWeight.w500,
    );

    // 날짜 숫자 위젯
    Widget dayText = Text(
      '${date.day}',
      style: textStyle,
    );

    // 메모가 있는 날짜인 경우 숫자를 원으로 감싸기
    if (hasMemo) {
      dayText = Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected || isToday ? Colors.transparent : Colors.black.withOpacity(0.1),
        ),
        child: Center(
          child: dayText,
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.all(6.0),
      decoration: isSelected
          ? BoxDecoration(
        color: Color(0xffD0EE17),
        shape: BoxShape.circle,
      )
          : isToday
          ? BoxDecoration(
        color: Colors.grey,
        shape: BoxShape.circle,
      )
          : hasMemo
          ? BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Color(0xffD0EE17), width: 1),
      )
          : null,
      alignment: Alignment.center,
      child: dayText,
    );
  }

  Widget _uncheckedMemo() {
    return Obx(() {
      if (repository.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }
      if (repository.fastmemo.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  '해당 날짜에 기록된 메모가 없습니다.',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Color(0xffFFFFFF),
                  ),
                ),
                SizedBox(height: 20),
                _emptyNextButton(),
              ],
            ),
          ),
        );
      }
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Color(0xff323232),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${DateFormat('MM월 dd일').format(repository.fastmemo.first.date)} 빠른 메모',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Color(0xffFFFFFF),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => FastMemoDetailPage(), arguments: repository.selectedDate.value);
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
              Column(
                children: repository.fastmemo.map((memo) {
                  bool isSelected = _selectedMap[memo.id] ?? false;

                  String iconPath = isSelected
                      ? 'assets/develop/is-checked.svg'
                      : memo.isChecked
                      ? 'assets/develop/is-already-checked.svg'
                      : 'assets/develop/is-not-checked.svg';

                  Color containerColor = isSelected
                      ? Color(0xff1C1B1B).withOpacity(0.5)
                      : memo.isChecked
                      ? Color(0xff1C1B1B).withOpacity(0.1)
                      : Color(0xff1C1B1B).withOpacity(0.3);

                  Color textColor = isSelected
                      ? Color(0xffFFFFFF)
                      : memo.isChecked
                      ? Color(0xffFFFFFF).withOpacity(0.1)
                      : Color(0xffFFFFFF);

                  BorderSide borderSide = isSelected
                      ? BorderSide(color: Color(0xffD0EE17), width: 1)
                      : BorderSide(color: Colors.transparent, width: 1);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: GestureDetector(
                      onTap: () {
                        if (!memo.isChecked) {
                          // isChecked가 false일 때만 상태 변경 가능
                          setState(() {
                            _selectedMap[memo.id] = !isSelected;
                          });
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: containerColor,
                          border: Border.all(
                              color: borderSide.color, width: borderSide.width),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 20),
                          leading: SvgPicture.asset(
                            iconPath,
                            width: 24,
                            height: 24,
                          ),
                          title: Container(
                            child: Text(
                              memo.content,
                              style: TextStyle(
                                color: textColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              _buildCompleteButton(),
              SizedBox(height: 30),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildCompleteButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 105),
      child: ElevatedButton(
        onPressed: _completeSelectedMemos,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xff1C1B1B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10),
        ),
        child: Center(
          child: Text(
            "선택하기",
            style: TextStyle(
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Color(0xffD0EE17)),
          ),
        ),
      ),
    );
  }

  Widget _emptyNextButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 105),
      child: GestureDetector(
        onTap: () {
          Get.to(() => FastMemoDetailPage(), arguments: repository.selectedDate.value);
        },
        child: Center(
          child: Text(
            "작성하기",
            style: TextStyle(
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Color(0xffD0EE17)),
          ),
        ),
      ),
    );
  }

  Future<void> _completeSelectedMemos() async {
    List<int> selectedIds = _selectedMap.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    if (selectedIds.isNotEmpty) {
      await repository.bulkUpdateIsChecked(true, selectedIds);
      setState(() {
        _selectedMap.clear();
      });
    }
  }
}
