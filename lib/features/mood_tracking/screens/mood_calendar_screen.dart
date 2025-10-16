import 'package:flutter/material.dart';
import 'package:mood_tracker/features/mood_tracking/models/mood_entry.dart';
import 'package:mood_tracker/features/mood_tracking/widgets/mood_calendar.dart';
import 'package:mood_tracker/features/mood_tracking/widgets/mood_stats_card.dart';

class MoodCalendarScreen extends StatelessWidget {
  final Map<DateTime, MoodEntry> entries;
  final DateTime currentMonth;
  final VoidCallback onAddEntry;
  final ValueChanged<DateTime> onDateSelected;
  final VoidCallback onChangeMonth;

  const MoodCalendarScreen({
    super.key,
    required this.entries,
    required this.currentMonth,
    required this.onAddEntry,
    required this.onDateSelected,
    required this.onChangeMonth,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${_getMonthName(currentMonth.month)} ${currentMonth.year}',
          style: TextStyle(fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: onChangeMonth,
            tooltip: 'Выбрать месяц',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Статистика за месяц
            MoodStatsCard(entries: entries, currentMonth: currentMonth),
            SizedBox(height: 16),
            // Заголовок дней недели
            _buildWeekDaysHeader(),
            // Основной календарь
            MoodCalendar(
              entries: entries,
              selectedMonth: currentMonth,
              onDateSelected: onDateSelected,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onAddEntry,
        child: Icon(Icons.add),
        tooltip: 'Добавить запись о настроении',
      ),
    );
  }

  Widget _buildWeekDaysHeader() {
    const weekDays = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
    return Row(
      children: weekDays.map((day) => Expanded(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            day,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
          ),
        ),
      )).toList(),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь',
      'Июль', 'Август', 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь'
    ];
    return months[month - 1];
  }
}