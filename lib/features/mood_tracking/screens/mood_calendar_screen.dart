import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mood_tracker/features/mood_tracking/models/mood_entry.dart';
import 'package:mood_tracker/features/mood_tracking/screens/mood_entry_screen.dart';
import 'package:mood_tracker/features/mood_tracking/widgets/mood_calendar.dart';
import 'package:mood_tracker/features/mood_tracking/widgets/mood_stats_card.dart';
import 'package:mood_tracker/shared/providers.dart';
import 'package:mood_tracker/features/mood_tracking/widgets/app_bottom_navigation_bar.dart';

class MoodCalendarScreen extends ConsumerStatefulWidget {
  const MoodCalendarScreen({super.key});

  @override
  ConsumerState<MoodCalendarScreen> createState() => _MoodCalendarScreenState();
}

class _MoodCalendarScreenState extends ConsumerState<MoodCalendarScreen> {
  void _showEntryForm(DateTime date, [MoodEntry? existingEntry]) async {
    final repository = ref.read(recordRepositoryProvider);

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MoodEntryScreen(
          selectedDate: date,
          existingEntry: existingEntry,
          onSave: (entry) {
            repository.add(entry);
            refreshAllProviders(ref);
          },
          onCancel: () => Navigator.pop(context),
        ),
      ),
    );
  }

  void _previousMonth() {
    final currentMonth = ref.read(currentMonthProvider);
    ref.read(currentMonthProvider.notifier).state =
        DateTime(currentMonth.year, currentMonth.month - 1, 1);
  }

  void _nextMonth() {
    final currentMonth = ref.read(currentMonthProvider);
    ref.read(currentMonthProvider.notifier).state =
        DateTime(currentMonth.year, currentMonth.month + 1, 1);
  }

  void _handleDateSelected(DateTime date) {
    final repository = ref.read(recordRepositoryProvider);
    final existingEntry = repository.getByDate(date);

    if (existingEntry != null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Запись за ${_formatDate(date)}'),
          content: const Text('Что вы хотите сделать с этой записью?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _showEntryForm(date, existingEntry);
              },
              child: const Text('Редактировать'),
            ),
            TextButton(
              onPressed: () {
                repository.deleteByDate(date);
                refreshAllProviders(ref);
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Запись за ${_formatDate(date)} удалена'),
                    action: SnackBarAction(
                      label: 'Отменить',
                      onPressed: () {
                        repository.add(existingEntry);
                        refreshAllProviders(ref);
                      },
                    ),
                  ),
                );
              },
              child: const Text('Удалить', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена'),
            ),
          ],
        ),
      );
    } else {
      _showEntryForm(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentMonth = ref.watch(currentMonthProvider);
    final entries = ref.watch(moodEntriesProvider);
    final canGoNext = ref.watch(canGoNextMonthProvider);

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
            onPressed: _previousMonth,
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            tooltip: 'Следующий месяц',
            onPressed: canGoNext ? _nextMonth : null,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const MoodStatsCard(),
            const SizedBox(height: 16),
            _buildWeekDaysHeader(),
            MoodCalendar(
              entries: entries,
              selectedMonth: currentMonth,
              onDateSelected: _handleDateSelected,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showEntryForm(DateTime.now()),
        child: const Icon(Icons.add),
        tooltip: 'Добавить запись о настроении',
      ),
      bottomNavigationBar: const AppBottomNavigationBar(currentIndex: 0),
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

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }
}