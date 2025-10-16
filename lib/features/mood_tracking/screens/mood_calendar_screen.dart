import 'package:flutter/material.dart';
import 'package:mood_tracker/features/mood_tracking/models/mood_entry.dart';
import 'package:mood_tracker/features/mood_tracking/widgets/mood_calendar.dart';
import 'package:mood_tracker/features/mood_tracking/widgets/mood_stats_card.dart';

class MoodCalendarScreen extends StatelessWidget {
  final Map<DateTime, MoodEntry> entries;
  final DateTime currentMonth;
  final VoidCallback onAddEntry;
  final ValueChanged<DateTime> onDateSelected;
  final VoidCallback onNextMonth;
  final VoidCallback onPreviousMonth;
  final bool canGoNext;

  const MoodCalendarScreen({
    super.key,
    required this.entries,
    required this.currentMonth,
    required this.onAddEntry,
    required this.onDateSelected,
    required this.onNextMonth,
    required this.onPreviousMonth,
    required this.canGoNext,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${_getMonthName(currentMonth.month)} ${currentMonth.year}',
          style: const TextStyle(fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            tooltip: 'Предыдущий месяц',
            onPressed: onPreviousMonth,
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            tooltip: 'Следующий месяц',
            onPressed: canGoNext ? onNextMonth : null,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            MoodStatsCard(entries: entries, currentMonth: currentMonth),
            const SizedBox(height: 16),
            _buildWeekDaysHeader(),
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
        child: const Icon(Icons.add),
        tooltip: 'Добавить запись о настроении',
      ),
    );
  }

  Widget _buildWeekDaysHeader() {
    const weekDays = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
    return Row(
      children: weekDays.map((day) {
        return Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              day,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
            ),
          ),
        );
      }).toList(),
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