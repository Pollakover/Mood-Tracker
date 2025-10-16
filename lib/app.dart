import 'package:flutter/material.dart';
import 'package:mood_tracker/features/mood_tracking/state/mood_container.dart';

class MoodTrackerApp extends StatelessWidget {
  const MoodTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Трекер Настроения',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MoodContainer(),
      debugShowCheckedModeBanner: false,
    );
  }
}