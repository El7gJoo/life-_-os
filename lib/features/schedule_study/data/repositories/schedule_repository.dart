import '../models/schedule_item_model.dart';

abstract class ScheduleRepository {
  Future<void> addItem(ScheduleItemModel item);
  List<ScheduleItemModel> getItems();
  List<ScheduleItemModel> getItemsForDate(DateTime date);
  List<ScheduleItemModel> getItemsForWeekday(int weekday);
  Future<void> updateItem(ScheduleItemModel item);
  Future<void> deleteItem(String id);
  Future<void> markComplete(String id, {String? ledgerEntryId});
  Future<void> undoComplete(String id);
  Future<void> applyEmergencyShift({int shiftMinutes = 60});
  Map<String, dynamic> exportAll();
  Future<void> importAll(Map<String, dynamic> data);
}
