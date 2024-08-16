import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nero_app/drf/calendar/controller/drf_calendar_controller.dart';
import 'package:nero_app/drf/calendar/fastlog/controller/drf_fastlog_controller.dart';
import 'package:nero_app/drf/calendar/fastlog/page/drf_fastlog_page.dart';
import 'package:table_calendar/table_calendar.dart';

class DrfCalendarPage extends StatelessWidget {
  final DrfCalendarController controller = Get.put(DrfCalendarController());
  final DrfFastlogController fastlogController = Get.find<DrfFastlogController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('달력'),
      ),
      body: Column(
        children: [
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
                fastlogController.setSelectedDate(selectedDay);
                Get.to(() => DrfFastlogPage());
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
              daysOfWeekHeight: 40,
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
    );
  }
}
