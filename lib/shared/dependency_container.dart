import 'package:flutter/material.dart';
import 'package:mood_tracker/features/mood_tracking/models/record_repository.dart';

class DependencyContainer extends InheritedWidget {
  final RecordRepository recordRepository;

  const DependencyContainer({
    super.key,
    required super.child,
    required this.recordRepository,
  });

  static DependencyContainer of(BuildContext context) {
    final DependencyContainer? result =
    context.dependOnInheritedWidgetOfExactType<DependencyContainer>();
    assert(result != null, 'No DependencyContainer found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(DependencyContainer oldWidget) {
    return recordRepository != oldWidget.recordRepository;
  }
}

