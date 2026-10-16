import 'package:hive_flutter/hive_flutter.dart';
import '../models/schedule_item_model.dart';
import 'schedule_repository.dart';

class ScheduleRepositoryImpl implements ScheduleRepository {
  final Box _box;

  ScheduleRepositoryImpl(this._box);

  @override
  List<ScheduleItemModel> getItems() {
    final list = <ScheduleItemModel>[];
    for (final key in _box.keys) {
      final data = _box.get(key);
      if (data is Map) {
        list.add(ScheduleItemModel.fromJson(data));
      }
    }
    list.sort((a, b) => a.startTime.compareTo(b.startTime));
    return list;
  }

  @override
  Future<void> addItem(ScheduleItemModel item) async {
    await _box.put(item.id, item.toJson());
  }

  @override
  Future<void> updateItem(ScheduleItemModel item) async {
    await _box.put(item.id, item.toJson());
  }

  @override
  Future<void> deleteItem(String id) async {
    await _box.delete(id);
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
