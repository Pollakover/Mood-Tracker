import 'package:flutter/material.dart';
import 'package:mood_tracker/app.dart';
import 'package:mood_tracker/shared/service_locator.dart';

void main() {
  setupServiceLocator();
  runApp(const MoodTrackerApp());
}