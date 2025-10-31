// lib/models/record_repository.dart
import 'package:mood_tracker/features/mood_tracking/models/mood_entry.dart';

class RecordRepository {
  RecordRepository._privateConstructor();
  static final RecordRepository _instance = RecordRepository._privateConstructor();
  factory RecordRepository() => _instance;

  final List<MoodEntry> _records = [];

  List<MoodEntry> getAll() => List.unmodifiable(_records);

  List<MoodEntry> getRecordsSortedByDate() {
    _records.sort((a, b) => b.date.compareTo(a.date));
    return List.unmodifiable(_records);
  }

  void add(MoodEntry r) {
    // Удаляем старую запись на эту дату (если есть)
    _records.removeWhere((record) =>
    record.date.year == r.date.year &&
        record.date.month == r.date.month &&
        record.date.day == r.date.day);

    _records.add(r);
  }

  void update(MoodEntry r) {
    final index = _records.indexWhere((record) => record.id == r.id);
    if (index != -1) {
      _records[index] = r;
    }
  }

  void delete(String id) {
    _records.removeWhere((record) => record.id == id);
  }

  void deleteByDate(DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    _records.removeWhere((record) =>
    record.date.year == normalizedDate.year &&
        record.date.month == normalizedDate.month &&
        record.date.day == normalizedDate.day);
  }

  MoodEntry? getByDate(DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    try {
      return _records.firstWhere((record) =>
      record.date.year == normalizedDate.year &&
          record.date.month == normalizedDate.month &&
          record.date.day == normalizedDate.day);
    } catch (e) {
      return null;
    }
  }

  MoodEntry? getById(String id) {
    try {
      return _records.firstWhere((record) => record.id == id);
    } catch (e) {
      return null;
    }
  }

  Map<DateTime, MoodEntry> getEntriesMap() {
    final map = <DateTime, MoodEntry>{};
    for (final record in _records) {
      final normalizedDate = DateTime(record.date.year, record.date.month, record.date.day);
      map[normalizedDate] = record;
    }
    return map;
  }
}