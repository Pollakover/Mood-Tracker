import 'package:flutter/cupertino.dart';

@immutable
class MoodEntry {
  final String id;
  final DateTime date;
  final String moodValue;
  final String? note;

  const MoodEntry({
    required this.id,
    required this.date,
    required this.moodValue,
    this.note,
  });

  MoodEntry copyWith({
    String? id,
    DateTime? date,
    String? moodValue,
    String? note,
  }) {
    return MoodEntry(
      id: id ?? this.id,
      date: date ?? this.date,
      moodValue: moodValue ?? this.moodValue,
      note: note ?? this.note,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.millisecondsSinceEpoch,
      'moodValue': moodValue,
      'note': note,
    };
  }

  factory MoodEntry.fromMap(Map<String, dynamic> map) {
    return MoodEntry(
      id: map['id'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      moodValue: map['moodValue'] as String,
      note: map['note'] as String?,
    );
  }

  @override
  String toString() {
    return 'MoodEntry(id: $id, date: $date, moodValue: $moodValue, note: $note)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MoodEntry &&
        other.id == id &&
        other.date == date &&
        other.moodValue == moodValue &&
        other.note == note;
  }

  @override
  int get hashCode {
    return id.hashCode ^ date.hashCode ^ moodValue.hashCode ^ note.hashCode;
  }
}