import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mood_tracker/features/mood_tracking/models/mood_entry.dart';
import 'package:mood_tracker/features/mood_tracking/models/record_repository.dart';

// Провайдер для репозитория
final recordRepositoryProvider = Provider<RecordRepository>((ref) {
  return RecordRepository();
});

// Провайдер для текущего месяца в календаре
final currentMonthProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month);
});

// Провайдер для проверки возможности перехода к следующему месяцу
final canGoNextMonthProvider = Provider<bool>((ref) {
  final currentMonth = ref.watch(currentMonthProvider);
  final now = DateTime.now();
  final nextMonth = DateTime(currentMonth.year, currentMonth.month + 1);
  final thisMonth = DateTime(now.year, now.month);
  return !nextMonth.isAfter(thisMonth);
});

// Провайдер для записей настроения
final moodEntriesProvider = Provider<Map<DateTime, MoodEntry>>((ref) {
  final repository = ref.watch(recordRepositoryProvider);
  return repository.getEntriesMap();
});

// Провайдер для отсортированного списка записей
final sortedMoodEntriesProvider = Provider<List<MoodEntry>>((ref) {
  final entriesMap = ref.watch(moodEntriesProvider);
  final repository = ref.read(recordRepositoryProvider);
  return repository.getRecordsSortedByDate();
});

// Функция для обновления всех связанных провайдеров
void refreshAllProviders(WidgetRef ref) {
  ref.refresh(moodEntriesProvider);
  ref.refresh(sortedMoodEntriesProvider);
}