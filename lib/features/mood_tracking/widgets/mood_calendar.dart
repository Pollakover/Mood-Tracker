import 'package:flutter/material.dart';
import 'package:mood_tracker/features/mood_tracking/models/mood_entry.dart';
import 'package:mood_tracker/shared/app_constants.dart';
import 'package:go_router/go_router.dart';

class MoodCalendar extends StatelessWidget {
  final Map<DateTime, MoodEntry> entries;
  final DateTime selectedMonth;
  final ValueChanged<DateTime> onDateSelected;

  const MoodCalendar({
    super.key,
    required this.entries,
    required this.selectedMonth,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final firstDay = DateTime(selectedMonth.year, selectedMonth.month, 1);
    final daysInMonth = DateTime(selectedMonth.year, selectedMonth.month + 1, 0).day;
    final startingWeekday = firstDay.weekday;

    final List<DateTime?> gridDays = [];

    for (int i = 1; i < startingWeekday; i++) {
      gridDays.add(null);
    }

    for (int i = 1; i <= daysInMonth; i++) {
      gridDays.add(DateTime(selectedMonth.year, selectedMonth.month, i));
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1.0,
      ),
      itemCount: gridDays.length,
      itemBuilder: (context, index) {
        final date = gridDays[index];

        if (date == null) {
          return const SizedBox.shrink();
        }

        final entry = entries[date];
        final isToday = _isSameDay(date, DateTime.now());
        final moodConfig = _getMoodConfig(entry?.moodValue);

        return GestureDetector(
          onTap: () => onDateSelected(date),
          child: Container(
            margin: const EdgeInsets.all(1.0),
            decoration: BoxDecoration(
              color: moodConfig?.color.withOpacity(0.3) ?? Colors.grey.shade100,
              borderRadius: BorderRadius.circular(6.0),
              border: Border.all(
                color: isToday ? Colors.blue : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 2,
                  right: 2,
                  child: Text(
                    '${date.day}',
                    style: TextStyle(
                      fontSize: 10,
                      color: isToday ? Colors.blue : Colors.grey.shade700,
                      fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
                if (moodConfig != null)
                  Center(
                    child: Text(
                      moodConfig.emoji,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  MoodConfig? _getMoodConfig(String? moodValue) {
    if (moodValue == null) return null;
    return AppConstants.getMoodConfig(moodValue);
  }
}