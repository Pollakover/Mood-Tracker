// lib/routes/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mood_tracker/features/mood_tracking/state/mood_container.dart';
import 'package:mood_tracker/features/mood_tracking/screens/home_screen.dart';
import 'package:mood_tracker/features/mood_tracking/screens/records_list_screen.dart';
import 'package:mood_tracker/features/mood_tracking/screens/settings_screen.dart';

final AppRouter appRouter = AppRouter();

class AppRouter {
  late final GoRouter router;

  AppRouter() {
    router = GoRouter(
      initialLocation: '/home', // Изменено с '/mood' на '/home'
      routes: <GoRoute>[
        GoRoute(
          path: '/',
          name: 'root',
          redirect: (context, state) => '/home', // Редирект с корня на главную
        ),
        GoRoute(
          path: '/home',
          name: 'home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/mood',
          name: 'mood',
          builder: (context, state) => const MoodContainer(),
        ),
        GoRoute(
          path: '/list',
          name: 'list',
          builder: (context, state) => const RecordsListScreen(),
        ),
        GoRoute(
          path: '/settings',
          name: 'settings',
          builder: (context, state) => const SettingsScreen(),
        ),
      ],
    );
  }
}