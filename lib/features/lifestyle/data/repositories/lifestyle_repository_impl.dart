import 'package:hive_flutter/hive_flutter.dart';
import '../models/lifestyle_log_model.dart';
import 'lifestyle_repository.dart';

class LifestyleRepositoryImpl implements LifestyleRepository {
  final Box _box;

  LifestyleRepositoryImpl(this._box);

  @override
  LifestyleLogModel getLogForDate(String date) {
    final raw = _box.get(date);
    if (raw is Map) {
      return LifestyleLogModel.fromJson(raw);
    }
    return LifestyleLogModel(date: date);
  }

  @override
  Future<void> saveLog(LifestyleLogModel log) async {
    await _box.put(log.date, log.toJson());
  }

  @override
  List<LifestyleLogModel> getAllLogs() {
    final list = <LifestyleLogModel>[];
    for (final key in _box.keys) {
      final raw = _box.get(key);
      if (raw is Map) {
        list.add(LifestyleLogModel.fromJson(raw));
      }
    }
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  @override
  Map<String, dynamic> exportAll() => Map<String, dynamic>.from(_box.toMap().map(
        (k, v) => MapEntry(k.toString(), v),
      ));

  @override
  Future<void> importAll(Map<String, dynamic> data) async {
    await _box.clear();
    await _box.putAll(data);
  }
}
