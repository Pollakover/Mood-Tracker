import 'package:get_it/get_it.dart';
import 'package:mood_tracker/features/mood_tracking/models/record_repository.dart';

final GetIt getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerLazySingleton<RecordRepository>(() => RecordRepository());
  getIt.allowReassignment = true;
}