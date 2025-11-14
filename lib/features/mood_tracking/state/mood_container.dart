import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mood_tracker/features/mood_tracking/models/mood_entry.dart';
import 'package:mood_tracker/features/mood_tracking/screens/mood_calendar_screen.dart';
import 'package:mood_tracker/features/mood_tracking/screens/mood_entry_screen.dart';
import 'package:mood_tracker/shared/providers.dart';

class MoodContainer extends ConsumerWidget {
  const MoodContainer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentMonth = ref.watch(currentMonthProvider);
    final entries = ref.watch(moodEntriesProvider);
    final canGoNext = ref.watch(canGoNextMonthProvider);
    final repository = ref.read(recordRepositoryProvider);

    void _showEntryForm(DateTime date, [MoodEntry? existingEntry]) async {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MoodEntryScreen(
            selectedDate: date,
            existingEntry: existingEntry,
            onSave: (entry) {
              repository.add(entry);
              ref.refresh(moodEntriesProvider);
            },
            onCancel: () => Navigator.pop(context),
          ),
        ),
      );
    }

    void _previousMonth() {
      ref.read(currentMonthProvider.notifier).state =
          DateTime(currentMonth.year, currentMonth.month - 1, 1);
    }

    void _nextMonth() {
      ref.read(currentMonthProvider.notifier).state =
          DateTime(currentMonth.year, currentMonth.month + 1, 1);
    }

    void _handleDateSelected(DateTime date) {
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
                  ref.refresh(moodEntriesProvider);
                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Запись за ${_formatDate(date)} удалена'),
                      action: SnackBarAction(
                        label: 'Отменить',
                        onPressed: () {
                          repository.add(existingEntry);
                          ref.refresh(moodEntriesProvider);
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

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Трекер настроений',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: MoodCalendarScreen(
        entries: entries,
        currentMonth: currentMonth,
        onAddEntry: () => _showEntryForm(DateTime.now()),
        onDateSelected: _handleDateSelected,
        onNextMonth: _nextMonth,
        onPreviousMonth: _previousMonth,
        canGoNext: canGoNext,
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 0,
      onTap: (index) {
        switch (index) {
          case 0:
            break;
          case 1:
            context.go('/list');
            break;
          case 2:
            context.go('/settings');
            break;
        }
      },
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'Календарь',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
          label: 'Список',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Настройки',
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }
}