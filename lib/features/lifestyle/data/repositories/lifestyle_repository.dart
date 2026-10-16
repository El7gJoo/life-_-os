import '../models/lifestyle_log_model.dart';

abstract class LifestyleRepository {
  LifestyleLogModel getLogForDate(String date);
  Future<void> saveLog(LifestyleLogModel log);
  List<LifestyleLogModel> getAllLogs();
  Map<String, dynamic> exportAll();
  Future<void> importAll(Map<String, dynamic> data);
}
