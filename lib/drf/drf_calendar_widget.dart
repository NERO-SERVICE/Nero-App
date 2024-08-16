import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

class DrfCalendarWidget extends StatelessWidget {
  final Rx<DateTime> selectedDate;
  final Rx<DateTime> focusedDate;

  DrfCalendarWidget({
    required this.selectedDate,
    required this.focusedDate,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Obx(
            () => TableCalendar(
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: focusedDate.value,
              locale: 'ko_KR',
              selectedDayPredicate: (day) {
                return isSameDay(selectedDate.value, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                selectedDate.value = selectedDay;
                focusedDate.value = focusedDay;
                Navigator.pop(context, selectedDay);
              },
              onPageChanged: (focusedDay) {
                focusedDate.value = focusedDay;
              },
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                leftChevronIcon: Icon(
                  Icons.chevron_left,
                  color: Colors.black,
                ),
                rightChevronIcon: Icon(
                  Icons.chevron_right,
                  color: Colors.black,
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
