import 'package:flutter/material.dart';
import 'package:nero_app/app_colors.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarWidget extends StatefulWidget {
  final DateTime initialSelectedDate;
  final DateTime initialFocusedDate;
  final Color selectedColor;
  final Set<DateTime>? markedDates;

  CalendarWidget({
    required this.initialSelectedDate,
    required this.initialFocusedDate,
    this.selectedColor = const Color(0xffD0EE17),
    this.markedDates,
  });

  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  late DateTime selectedDate;
  late DateTime focusedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialSelectedDate;
    focusedDate = widget.initialFocusedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TableCalendar(
        firstDay: DateTime.utc(2010, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: focusedDate,
        locale: 'ko_KR',
        selectedDayPredicate: (day) {
          return isSameDay(selectedDate, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            selectedDate = selectedDay;
            this.focusedDate = focusedDay;
          });
          Navigator.pop(context, selectedDay);
        },
        onPageChanged: (focusedDay) {
          setState(() {
            this.focusedDate = focusedDay;
          });
        },
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: TextStyle(
            color: AppColors.titleColor,
            fontWeight: FontWeight.bold,
          ),
          leftChevronIcon: Icon(
            Icons.chevron_left,
            color: AppColors.titleColor,
          ),
          rightChevronIcon: Icon(
            Icons.chevron_right,
            color: AppColors.titleColor,
          ),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: TextStyle(color: AppColors.titleColor),
          weekendStyle: TextStyle(color: AppColors.titleColor),
        ),
        daysOfWeekHeight: 40,
        calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(
            color: AppColors.secondaryTextColor,
            shape: BoxShape.circle,
          ),
          selectedDecoration: BoxDecoration(
            color: widget.selectedColor,
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
            color: AppColors.titleColor,
          ),
          selectedTextStyle: TextStyle(
            color: AppColors.titleColor,
          ),
          defaultTextStyle: TextStyle(
            color: AppColors.secondaryTextColor,
          ),
          weekendTextStyle: TextStyle(
            color: AppColors.weekendTextColor,
          ),
        ),
        calendarBuilders: CalendarBuilders(
          defaultBuilder: (context, date, focusedDay) {
            return _buildDayCell(date);
          },
          selectedBuilder: (context, date, focusedDay) {
            return _buildDayCell(date, isSelected: true);
          },
          todayBuilder: (context, date, focusedDay) {
            return _buildDayCell(date, isToday: true);
          },
          outsideBuilder: (context, date, focusedDay) {
            return Container();
          },
        ),
      ),
    );
  }

  Widget _buildDayCell(DateTime date,
      {bool isSelected = false, bool isToday = false}) {
    bool hasRecord = false;

    if (widget.markedDates != null) {
      hasRecord = widget.markedDates!
          .contains(DateTime(date.year, date.month, date.day));
    }

    TextStyle textStyle = TextStyle(
      color: isSelected
          ? AppColors.titleColor
          : isToday
              ? AppColors.titleColor
              : (date.weekday == DateTime.saturday ||
                      date.weekday == DateTime.sunday)
                  ? AppColors.weekendTextColor
                  : AppColors.secondaryTextColor,
      fontWeight: FontWeight.w500,
    );

    // 날짜 숫자 위젯
    Widget dayText = Text(
      '${date.day}',
      style: textStyle,
    );

    if (hasRecord) {
      dayText = Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected || isToday
              ? Colors.transparent
              : AppColors.selectedButtonColor,
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
              color: widget.selectedColor,
              shape: BoxShape.circle,
            )
          : isToday
              ? BoxDecoration(
                  color: AppColors.secondaryTextColor,
                  shape: BoxShape.circle,
                )
              : hasRecord
                  ? BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: widget.selectedColor, width: 1),
                    )
                  : null,
      alignment: Alignment.center,
      child: dayText,
    );
  }
}
