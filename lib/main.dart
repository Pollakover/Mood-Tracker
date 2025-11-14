import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mood_tracker/app.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MoodTrackerApp(),
    ),
  );
}