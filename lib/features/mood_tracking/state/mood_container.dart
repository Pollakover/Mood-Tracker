// mood_container.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mood_tracker/features/mood_tracking/models/mood_entry.dart';
import 'package:mood_tracker/features/mood_tracking/screens/mood_calendar_screen.dart';
import 'package:mood_tracker/features/mood_tracking/screens/mood_entry_screen.dart';
import 'package:mood_tracker/models/record_repository.dart';

enum MoodScreen { calendar, entry }

class MoodContainer extends StatefulWidget {
  const MoodContainer({super.key});

  @override
  State<MoodContainer> createState() => _MoodContainerState();
}

class _MoodContainerState extends State<MoodContainer> {
  final RecordRepository _repository = RecordRepository();
  MoodScreen _currentScreen = MoodScreen.calendar;
  DateTime _currentMonth = DateTime(DateTime.now().year, DateTime.now().month);
  DateTime? _selectedDate;
  MoodEntry? _editingEntry;

  Map<DateTime, MoodEntry> get _entries => _repository.getEntriesMap();

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
    _repository.add(entry);
    setState(() {
      _showCalendar();
    });
  }

  void _deleteEntry(DateTime date) {
    final removedEntry = _repository.getByDate(date);
    _repository.deleteByDate(date);

    setState(() {});

    if (removedEntry != null) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Запись за ${_formatDate(date)} удалена'),
          action: SnackBarAction(
            label: 'Отменить',
            onPressed: () {
              _repository.add(removedEntry);
              setState(() {});
            },
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _handleDateSelected(DateTime date) {
    final existingEntry = _repository.getByDate(date);

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

  int _selectedTab = 0;

  void _onBottomNavTapped(int index) {
    setState(() => _selectedTab = index);
    switch (index) {
      case 0:
        if (_currentScreen != MoodScreen.calendar) {
          _showCalendar();
        }
        break;
      case 1:
        context.go('/list');
        break;
      case 2:
        context.go('/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    switch (_currentScreen) {
      case MoodScreen.calendar:
        content = MoodCalendarScreen(
          entries: _entries,
          currentMonth: _currentMonth,
          onAddEntry: () => _showEntryForm(DateTime.now()),
          onDateSelected: _handleDateSelected,
          onNextMonth: _nextMonth,
          onPreviousMonth: _previousMonth,
          canGoNext: _canGoNextMonth(),
        );
        break;
      case MoodScreen.entry:
        content = MoodEntryScreen(
          selectedDate: _selectedDate!,
          existingEntry: _editingEntry,
          onSave: _addOrUpdateEntry,
          onCancel: _showCalendar,
        );
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Трекер настроений',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: content,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTab,
        onTap: _onBottomNavTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.bold,
        ),
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
      ),
    );
  }
}