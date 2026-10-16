import '../models/lifestyle_log_model.dart';

abstract class LifestyleRepository {
  Future<void> addLog(LifestyleLogModel log);
  List<LifestyleLogModel> getLogs();
  List<LifestyleLogModel> getLogsForDate(DateTime date, [int dayBoundaryHour = 4]);
  List<LifestyleLogModel> getLogsOfType(String type);
  Future<void> deleteLog(String id);

  int getTodayMealCount([int dayBoundaryHour = 4]);
  int getTodayWaterCups([int dayBoundaryHour = 4]);
  bool hasTodayWorkout([int dayBoundaryHour = 4]);

  Map<String, dynamic> exportAll();
  Future<void> importAll(Map<String, dynamic> data);
}
