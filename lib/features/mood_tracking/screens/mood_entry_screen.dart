import 'package:flutter/material.dart';
import 'package:mood_tracker/features/mood_tracking/models/mood_entry.dart';
import 'package:mood_tracker/features/mood_tracking/widgets/mood_selector.dart';

class MoodEntryScreen extends StatefulWidget {
  final DateTime selectedDate;
  final MoodEntry? existingEntry;
  final void Function(MoodEntry entry) onSave;
  final VoidCallback onCancel;

  const MoodEntryScreen({
    super.key,
    required this.selectedDate,
    this.existingEntry,
    required this.onSave,
    required this.onCancel,
  });

  @override
  State<MoodEntryScreen> createState() => _MoodEntryScreenState();
}

class _MoodEntryScreenState extends State<MoodEntryScreen> {
  final _noteController = TextEditingController();
  String? _selectedMood;

  @override
  void initState() {
    super.initState();
    // Если редактируем существующую запись, заполняем поля
    if (widget.existingEntry != null) {
      _selectedMood = widget.existingEntry!.moodValue;
      _noteController.text = widget.existingEntry!.note ?? '';
    }
  }

  void _submit() {
    if (_selectedMood == null) return;

    final newEntry = MoodEntry(
      id: widget.existingEntry?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      date: widget.selectedDate,
      moodValue: _selectedMood!,
      note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
    );

    widget.onSave(newEntry);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingEntry == null ? 'Новая запись' : 'Редактировать запись'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Дата записи
            Text(
              'Дата: ${_formatDate(widget.selectedDate)}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 20),

            // Заголовок выбора настроения
            Text(
              'Как вы себя чувствуете?',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 12),

            // Селектор настроения
            MoodSelector(
              selectedMood: _selectedMood,
              onMoodSelected: (mood) {
                setState(() {
                  _selectedMood = mood;
                });
              },
            ),
            SizedBox(height: 24),

            // Поле для заметки
            TextField(
              controller: _noteController,
              decoration: InputDecoration(
                labelText: 'Заметка (необязательно)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 24),

            // Кнопки действий
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _selectedMood != null ? _submit : null,
                    child: Text(widget.existingEntry == null ? 'Добавить' : 'Сохранить'),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: widget.onCancel,
                    child: Text('Отмена'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }
}