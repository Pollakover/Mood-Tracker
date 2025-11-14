import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mood_tracker/features/mood_tracking/models/mood_entry.dart';
import 'package:mood_tracker/shared/app_constants.dart';
import 'package:mood_tracker/shared/providers.dart';

class RecordsListScreen extends ConsumerWidget {
  const RecordsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final records = ref.watch(sortedMoodEntriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Список записей'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/mood'),
        ),
      ),
      body: records.isEmpty
          ? _buildEmptyState(context)
          : ListView.builder(
        itemCount: records.length,
        itemBuilder: (context, index) {
          final entry = records[index];
          final moodConfig = AppConstants.getMoodConfig(entry.moodValue);

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: ListTile(
              leading: Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: moodConfig.color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(child: Text(moodConfig.emoji, style: const TextStyle(fontSize: 16))),
              ),
              title: Text(moodConfig.label, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_formatDate(entry.date)),
                  if (entry.note != null && entry.note!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(entry.note!,
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                      ),
                    ),
                ],
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              onTap: () => _showEntryDetails(context, entry),
            ),
          );
        },
      ),
    );
  }

  // Остальные методы остаются без изменений...
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.list_alt, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text('Нет записей', style: TextStyle(fontSize: 18, color: Colors.grey.shade600)),
          const SizedBox(height: 8),
          Text('Добавьте записи о настроении в календаре',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade500),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            icon: const Icon(Icons.calendar_today),
            label: const Text('Перейти к календарю'),
            onPressed: () => context.go('/mood'),
          ),
        ],
      ),
    );
  }

  void _showEntryDetails(BuildContext context, MoodEntry entry) {
    final moodConfig = AppConstants.getMoodConfig(entry.moodValue);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Запись от ${_formatDate(entry.date)}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Text(moodConfig.emoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 12),
              Text(moodConfig.label,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
            ]),
            const SizedBox(height: 16),
            if (entry.note != null && entry.note!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Заметка:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(entry.note!),
                ],
              )
            else
              Text('Без заметки', style: TextStyle(color: Colors.grey.shade600)),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Закрыть'))],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = ['января','февраля','марта','апреля','мая','июня','июля','августа','сентября','октября','ноября','декабря'];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}