import 'package:flutter/material.dart';
import 'package:mood_tracker/routes/app_router.dart';
import 'package:mood_tracker/shared/dependency_container.dart';
import 'package:mood_tracker/shared/service_locator.dart';
import 'package:mood_tracker/features/mood_tracking/models/record_repository.dart';

class MoodTrackerApp extends StatelessWidget {
  const MoodTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DependencyContainer(
      recordRepository: getIt<RecordRepository>(),
      child: MaterialApp.router(
        title: 'Трекер Настроения',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        routerConfig: appRouter.router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}