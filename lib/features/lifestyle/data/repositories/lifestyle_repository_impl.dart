import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/utils/date_utils.dart';
import '../models/lifestyle_log_model.dart';
import 'lifestyle_repository.dart';

class LifestyleRepositoryImpl implements LifestyleRepository {
  final Box _box;

  LifestyleRepositoryImpl(this._box);

  @override
  Future<void> addLog(LifestyleLogModel log) async {
    await _box.put(log.id, log.toJson());
  }

  @override
  List<LifestyleLogModel> getLogs() {
    final list = <LifestyleLogModel>[];
    for (final key in _box.keys) {
      final value = _box.get(key);
      if (value is Map) {
        list.add(LifestyleLogModel.fromJson(Map<String, dynamic>.from(value)));
      }
    }
    list.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return list;
  }

  @override
  List<LifestyleLogModel> getLogsForDate(DateTime date, [int dayBoundaryHour = 4]) =>
      getLogs()
          .where((log) => AppDateUtils.isSameLogicalDay(log.timestamp, date, dayBoundaryHour))
          .toList();

  @override
  List<LifestyleLogModel> getLogsOfType(String type) =>
      getLogs().where((log) => log.type == type).toList();

  @override
  Future<void> deleteLog(String id) async {
    await _box.delete(id);
  }

  @override
  int getTodayMealCount([int dayBoundaryHour = 4]) {
    return getLogsForDate(DateTime.now(), dayBoundaryHour)
        .where((l) => l.type == 'meal')
        .fold(0, (sum, l) => sum + (l.value ?? 1));
  }

  @override
  int getTodayWaterCups([int dayBoundaryHour = 4]) {
    return getLogsForDate(DateTime.now(), dayBoundaryHour)
        .where((l) => l.type == 'water')
        .fold(0, (sum, l) => sum + (l.value ?? 1));
  }

  @override
  bool hasTodayWorkout([int dayBoundaryHour = 4]) {
    return getLogsForDate(DateTime.now(), dayBoundaryHour)
        .any((l) => l.type == 'workout');
  }

  @override
  Map<String, dynamic> exportAll() => {
        'logs': getLogs().map((l) => l.toJson()).toList(),
      };

  @override
  Future<void> importAll(Map<String, dynamic> data) async {
    if (data['logs'] is List) {
      await _box.clear();
      for (final item in data['logs'] as List) {
        if (item is Map) {
          final log = LifestyleLogModel.fromJson(Map<String, dynamic>.from(item));
          await _box.put(log.id, log.toJson());
        }
      }
    }
  }
}
