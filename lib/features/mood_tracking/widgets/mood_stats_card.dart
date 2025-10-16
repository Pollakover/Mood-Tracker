// Файл: lib/features/mood_tracking/widgets/mood_stats_card.dart

import 'package:flutter/material.dart';
import 'package:mood_tracker/features/mood_tracking/models/mood_entry.dart';
import 'package:mood_tracker/shared/app_constants.dart';

class MoodStatsCard extends StatelessWidget {
  final Map<DateTime, MoodEntry> entries;
  final DateTime currentMonth;

  const MoodStatsCard({
    super.key,
    required this.entries,
    required this.currentMonth,
  });

  @override
  Widget build(BuildContext context) {
    final monthlyStats = _calculateMonthlyStats();
    final totalDaysWithEntries = monthlyStats.values.fold(0, (sum, count) => sum + count);

    if (totalDaysWithEntries == 0) {
      return _buildEmptyState(context);
    }

    final dominantMood = _findDominantMood(monthlyStats);

    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // Важно: предотвращает переполнение
          children: [
            Text(
              'Статистика за ${_getMonthName(currentMonth.month)}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Используем ListView для скролла статистики
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: 300, // Ограничиваем высоту статистики
              ),
              child: ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: _buildMoodProgressBars(context, monthlyStats, totalDaysWithEntries),
              ),
            ),

            const SizedBox(height: 16),

            if (dominantMood != null)
              _buildDominantMoodSection(context, dominantMood, monthlyStats[dominantMood]!, totalDaysWithEntries),
          ],
        ),
      ),
    );
  }

  /// Вычисляет статистику по настроениям за текущий месяц
  Map<MoodConfig, int> _calculateMonthlyStats() {
    final stats = <MoodConfig, int>{};

    // Инициализируем все возможные настроения нулевыми значениями
    for (final mood in AppConstants.availableMoods) {
      stats[mood] = 0;
    }

    // Подсчитываем записи за текущий месяц
    for (final entry in entries.values) {
      if (entry.date.year == currentMonth.year &&
          entry.date.month == currentMonth.month) {
        // Безопасный поиск настроения - исправление ошибки null check
        final moodConfig = AppConstants.availableMoods.firstWhere(
              (mood) => mood.value == entry.moodValue,
          orElse: () => AppConstants.availableMoods[2], // neutral по умолчанию
        );
        stats[moodConfig] = stats[moodConfig]! + 1;
      }
    }

    return stats;
  }

  /// Строит прогресс-бары для каждого настроения
  List<Widget> _buildMoodProgressBars(BuildContext context, Map<MoodConfig, int> stats, int total) {
    return stats.entries.map((entry) {
      final mood = entry.key;
      final count = entry.value;
      final percentage = total > 0 ? (count / total * 100) : 0;

      return Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(mood.emoji, style: const TextStyle(fontSize: 16)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    mood.label,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                Text(
                  '${percentage.toStringAsFixed(1)}%',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Container(
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.grey.shade200,
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: percentage / 100,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: mood.color,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  /// Секция с доминирующим настроением
  Widget _buildDominantMoodSection(BuildContext context, MoodConfig dominantMood, int count, int total) {
    final percentage = (count / total * 100);

    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: dominantMood.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: dominantMood.color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Text(dominantMood.emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Преобладающее настроение',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                Text(
                  dominantMood.label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${percentage.toStringAsFixed(0)}%',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// Находит наиболее часто встречающееся настроение
  MoodConfig? _findDominantMood(Map<MoodConfig, int> stats) {
    MoodConfig? dominantMood;
    int maxCount = 0;

    for (final entry in stats.entries) {
      if (entry.value > maxCount) {
        maxCount = entry.value;
        dominantMood = entry.key;
      }
    }

    // Возвращаем null если нет записей или все записи с нулевым счетом
    return maxCount > 0 ? dominantMood : null;
  }

  /// Состояние при отсутствии данных
  Widget _buildEmptyState(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.analytics_outlined,
              size: 48,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 12),
            Text(
              'Нет данных за этот месяц',
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Добавьте записи о настроении, чтобы увидеть статистику',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
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