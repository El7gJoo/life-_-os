import '../models/schedule_item_model.dart';

abstract class ScheduleRepository {
  List<ScheduleItemModel> getItems();
  Future<void> addItem(ScheduleItemModel item);
  Future<void> updateItem(ScheduleItemModel item);
  Future<void> deleteItem(String id);
  Map<String, dynamic> exportAll();
  Future<void> importAll(Map<String, dynamic> data);
}
