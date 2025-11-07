// lib/features/mood_tracking/state/mood_container.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mood_tracker/features/mood_tracking/models/mood_entry.dart';
import 'package:mood_tracker/features/mood_tracking/screens/mood_calendar_screen.dart';
import 'package:mood_tracker/features/mood_tracking/screens/mood_entry_screen.dart';
import 'package:mood_tracker/features/mood_tracking/models/record_repository.dart';
import 'package:mood_tracker/shared/dependency_container.dart';
import 'package:mood_tracker/shared/service_locator.dart';

class MoodContainer extends StatefulWidget {
  const MoodContainer({super.key});

  @override
  State<MoodContainer> createState() => _MoodContainerState();
}

class _MoodContainerState extends State<MoodContainer> {
  late RecordRepository _repositoryFromInherited;

  DateTime _currentMonth = DateTime(DateTime.now().year, DateTime.now().month);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _repositoryFromInherited = DependencyContainer.of(context).recordRepository;
  }

  RecordRepository get _repository => _repositoryFromInherited;

  Map<DateTime, MoodEntry> get _entries => _repository.getEntriesMap();

  void _showEntryForm(DateTime date, [MoodEntry? existingEntry]) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MoodEntryScreen(
          selectedDate: date,
          existingEntry: existingEntry,
          onSave: _addOrUpdateEntry,
          onCancel: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
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
    setState(() {});
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
                Navigator.pop(context);
                _showEntryForm(date, existingEntry);
              },
              child: const Text('Редактировать'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _deleteEntry(date);
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Трекер настроений',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: MoodCalendarScreen(
        entries: _entries,
        currentMonth: _currentMonth,
        onAddEntry: () => _showEntryForm(DateTime.now()),
        onDateSelected: (date) => _handleDateSelected(date),
        onNextMonth: _nextMonth,
        onPreviousMonth: _previousMonth,
        canGoNext: _canGoNextMonth(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTab,
        onTap: _onBottomNavTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(
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