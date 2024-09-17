import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nero_app/background_layout.dart';
import 'package:nero_app/develop/common/components/custom_app_bar.dart';
import 'package:nero_app/develop/fastmemo/controller/fastmemo_controller.dart';
import 'package:nero_app/develop/fastmemo/page/fast_memo_detail_page.dart';
import 'package:nero_app/develop/fastmemo/repository/fastmemo_repository.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../common/layout/common_layout.dart';

class FastMemoMainPage extends StatelessWidget {
  final FastmemoController controller = Get.put(FastmemoController());
  final FastmemoRepository repository = Get.find<FastmemoRepository>();

  @override
  Widget build(BuildContext context) {
    return CommonLayout(
      appBar: CustomAppBar(title: '빠른 메모'),
      body: BackgroundLayout(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            Obx(
              () => TableCalendar(
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.utc(2030, 3, 14),
                focusedDay: controller.focusedDay.value,
                locale: 'ko_KR',
                selectedDayPredicate: (day) {
                  return isSameDay(controller.selectedDay.value, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  controller.onDaySelected(selectedDay, focusedDay);
                  repository.setSelectedDate(selectedDay);
                  Get.to(() => FastMemoDetailPage());
                },
                onPageChanged: (focusedDay) {
                  controller.onPageChanged(focusedDay);
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
