import 'package:flutter/material.dart';

class MoodConfig {
  final String value;
  final String emoji;
  final String label;
  final Color color;
  final String imageUrl;

  const MoodConfig({
    required this.value,
    required this.emoji,
    required this.label,
    required this.color,
    required this.imageUrl,
  });
}

class AppConstants {
  static const List<MoodConfig> availableMoods = [
    MoodConfig(
      value: 'excellent',
      emoji: '😍',
      label: 'Отлично',
      color: Colors.green,
      imageUrl: 'https://emojiisland.com/cdn/shop/products/Heart_Eyes_Emoji_large.png?v=1571606037',
    ),
    MoodConfig(
      value: 'good',
      emoji: '😊',
      label: 'Хорошо',
      color: Colors.lightGreen,
      imageUrl: 'https://emojiisland.com/cdn/shop/products/Smiling_Face_Emoji_with_Blushed_Cheeks_large.png?v=1571606036',
    ),
    MoodConfig(
      value: 'neutral',
      emoji: '😐',
      label: 'Нормально',
      color: Colors.amber,
      imageUrl: 'https://emojiisland.com/cdn/shop/products/Neutral_Face_Emoji_large.png?v=1571606037',
    ),
    MoodConfig(
      value: 'bad',
      emoji: '😔',
      label: 'Плохо',
      color: Colors.orange,
      imageUrl: 'https://emojiisland.com/cdn/shop/products/Sad_Face_Emoji_large.png?v=1571606037',
    ),
    MoodConfig(
      value: 'terrible',
      emoji: '😢',
      label: 'Ужасно',
      color: Colors.red,
      imageUrl: 'https://emojiisland.com/cdn/shop/products/Crying_Face_Emoji_large.png?v=1571606037',
    ),
  ];

  static MoodConfig getMoodConfig(String value) {
    return availableMoods.firstWhere(
          (mood) => mood.value == value,
      orElse: () => availableMoods[2],
    );
  }
}