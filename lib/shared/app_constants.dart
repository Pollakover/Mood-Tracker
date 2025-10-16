// Файл: lib/shared/app_constants.dart

import 'package:flutter/material.dart';

class MoodConfig {
  final String value;
  final String emoji;
  final String label;
  final Color color;

  const MoodConfig({
    required this.value,
    required this.emoji,
    required this.label,
    required this.color,
  });
}

class AppConstants {
  static const List<MoodConfig> availableMoods = [
    MoodConfig(
      value: 'excellent',
      emoji: '😍',
      label: 'Отлично',
      color: Colors.green,
    ),
    MoodConfig(
      value: 'good',
      emoji: '😊',
      label: 'Хорошо',
      color: Colors.lightGreen,
    ),
    MoodConfig(
      value: 'neutral',
      emoji: '😐',
      label: 'Нормально',
      color: Colors.amber,
    ),
    MoodConfig(
      value: 'bad',
      emoji: '😔',
      label: 'Плохо',
      color: Colors.orange,
    ),
    MoodConfig(
      value: 'terrible',
      emoji: '😢',
      label: 'Ужасно',
      color: Colors.red,
    ),
  ];

  // Метод для поиска конфигурации по значению
  static MoodConfig getMoodConfig(String value) {
    return availableMoods.firstWhere(
          (mood) => mood.value == value,
      orElse: () => availableMoods[2], // neutral по умолчанию
    );
  }
}