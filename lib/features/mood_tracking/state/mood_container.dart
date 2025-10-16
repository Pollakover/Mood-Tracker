import 'package:flutter/material.dart';
import 'package:mood_tracker/features/mood_tracking/models/mood_entry.dart';
import 'package:mood_tracker/features/mood_tracking/screens/mood_calendar_screen.dart';
import 'package:mood_tracker/features/mood_tracking/screens/mood_entry_screen.dart';

enum MoodScreen { calendar, entry }

class MoodContainer extends StatefulWidget {
  const MoodContainer({super.key});

  @override
  State<MoodContainer> createState() => _MoodContainerState();
}

class _MoodContainerState extends State<MoodContainer> {
  final Map<DateTime, MoodEntry> _entries = {};
  MoodScreen _currentScreen = MoodScreen.calendar;
  DateTime _currentMonth = DateTime(DateTime.now().year, DateTime.now().month);
  DateTime? _selectedDate;
  MoodEntry? _editingEntry;

  void _showCalendar() {
    setState(() {
      _currentScreen = MoodScreen.calendar;
      _selectedDate = null;
      _editingEntry = null;
    });
  }

  void _showEntryForm(DateTime date, [MoodEntry? existingEntry]) {
    setState(() {
      _currentScreen = MoodScreen.entry;
      _selectedDate = date;
      _editingEntry = existingEntry;
    });
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
    });
  }

  void _nextMonth() {
    final now = DateTime.now();
    final next = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
    final thisMonth = DateTime(now.year, now.month);

    if (next.isAfter(thisMonth)) return;
    setState(() {
      _currentMonth = next;
    });
  }

  void _addOrUpdateEntry(MoodEntry entry) {
    setState(() {
      final normalizedDate =
      DateTime(entry.date.year, entry.date.month, entry.date.day);
      _entries[normalizedDate] = entry;
      _showCalendar();
    });
  }

  void _deleteEntry(DateTime date) {
    setState(() {
      final normalizedDate = DateTime(date.year, date.month, date.day);
      final removedEntry = _entries.remove(normalizedDate);

      if (removedEntry != null) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Запись за ${_formatDate(date)} удалена'),
            action: SnackBarAction(
              label: 'Отменить',
              onPressed: () {
                setState(() {
                  _entries[normalizedDate] = removedEntry;
                });
              },
            ),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    });
  }

  void _handleDateSelected(DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    final existingEntry = _entries[normalizedDate];

    if (existingEntry != null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Запись за ${_formatDate(date)}'),
          content: const Text('Что вы хотите сделать с этой записью?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showEntryForm(date, existingEntry);
              },
              child: const Text('Редактировать'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteEntry(date);
              },
              child: const Text('Удалить', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Отмена'),
            ),
          ],
        ),
      );
    } else {
      _showEntryForm(date);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }

  bool _canGoNextMonth() {
    final now = DateTime.now();
    final next = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
    final thisMonth = DateTime(now.year, now.month);
    return !next.isAfter(thisMonth);
  }

  @override
  Widget build(BuildContext context) {
    switch (_currentScreen) {
      case MoodScreen.calendar:
        return MoodCalendarScreen(
          entries: _entries,
          currentMonth: _currentMonth,
          onAddEntry: () => _showEntryForm(DateTime.now()),
          onDateSelected: _handleDateSelected,
          onNextMonth: _nextMonth,
          onPreviousMonth: _previousMonth,
          canGoNext: _canGoNextMonth(),
        );

      case MoodScreen.entry:
        return MoodEntryScreen(
          selectedDate: _selectedDate!,
          existingEntry: _editingEntry,
          onSave: _addOrUpdateEntry,
          onCancel: _showCalendar,
        );
    }
  }
}
