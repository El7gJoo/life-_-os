import 'package:hive_flutter/hive_flutter.dart';
import '../models/schedule_item_model.dart';
import 'schedule_repository.dart';

class ScheduleRepositoryImpl implements ScheduleRepository {
  final Box _box;

  ScheduleRepositoryImpl(this._box);

  @override
  Future<void> addItem(ScheduleItemModel item) async {
    await _box.put(item.id, item.toJson());
  }

  @override
  List<ScheduleItemModel> getItems() {
    final list = <ScheduleItemModel>[];
    for (final key in _box.keys) {
      final value = _box.get(key);
      if (value is Map) {
        list.add(ScheduleItemModel.fromJson(Map<String, dynamic>.from(value)));
      }
    }
    list.sort((a, b) {
      if (a.startHour != b.startHour) return a.startHour.compareTo(b.startHour);
      return a.startMinute.compareTo(b.startMinute);
    });
    return list;
  }

  @override
  List<ScheduleItemModel> getItemsForDate(DateTime date) {
    return getItems().where((item) {
      if (item.isRecurring) return item.weekday == date.weekday;
      if (item.specificDate != null) {
        return item.specificDate!.year == date.year &&
            item.specificDate!.month == date.month &&
            item.specificDate!.day == date.day;
      }
      return false;
    }).toList();
  }

  @override
  List<ScheduleItemModel> getItemsForWeekday(int weekday) =>
      getItems().where((item) => item.weekday == weekday).toList();

  @override
  Future<void> updateItem(ScheduleItemModel item) async {
    await _box.put(item.id, item.toJson());
  }

  @override
  Future<void> deleteItem(String id) async {
    await _box.delete(id);
  }

  @override
  Future<void> markComplete(String id, {String? ledgerEntryId}) async {
    final raw = _box.get(id);
    if (raw is Map) {
      final model = ScheduleItemModel.fromJson(Map<String, dynamic>.from(raw));
      final updated = model.copyWith(
        isCompleted: true,
        completedAt: DateTime.now(),
        ledgerEntryId: ledgerEntryId,
      );
      await _box.put(id, updated.toJson());
    }
  }

  @override
  Future<void> undoComplete(String id) async {
    final raw = _box.get(id);
    if (raw is Map) {
      final model = ScheduleItemModel.fromJson(Map<String, dynamic>.from(raw));
      final updated = model.copyWith(
        isCompleted: false,
        completedAt: null,
        ledgerEntryId: null,
      );
      await _box.put(id, updated.toJson());
    }
  }

  @override
  Future<void> applyEmergencyShift({int shiftMinutes = 60}) async {
    final items = getItems();
    for (final item in items) {
      if (!item.isCompleted) {
        final updated = item.copyWith(shiftMinutes: item.shiftMinutes + shiftMinutes);
        await _box.put(updated.id, updated.toJson());
      }
    }
  }

  @override
  Map<String, dynamic> exportAll() => {
        'items': getItems().map((i) => i.toJson()).toList(),
      };

  @override
  Future<void> importAll(Map<String, dynamic> data) async {
    if (data['items'] is List) {
      await _box.clear();
      for (final item in data['items'] as List) {
        if (item is Map) {
          final model = ScheduleItemModel.fromJson(Map<String, dynamic>.from(item));
          await _box.put(model.id, model.toJson());
        }
      }
    }
  }
}
