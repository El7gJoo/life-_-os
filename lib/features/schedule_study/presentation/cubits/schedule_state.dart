import 'package:equatable/equatable.dart';
import '../../data/models/schedule_item_model.dart';

class ScheduleState extends Equatable {
  final List<ScheduleItemModel> items;
  final DateTime selectedDate;
  final DateTime? targetWakeUpTime;
  final DateTime? targetBedtime;

  const ScheduleState({
    required this.items,
    required this.selectedDate,
    this.targetWakeUpTime,
    this.targetBedtime,
  });

  ScheduleState copyWith({
    List<ScheduleItemModel>? items,
    DateTime? selectedDate,
    DateTime? targetWakeUpTime,
    DateTime? targetBedtime,
  }) {
    return ScheduleState(
      items: items ?? this.items,
      selectedDate: selectedDate ?? this.selectedDate,
      targetWakeUpTime: targetWakeUpTime ?? this.targetWakeUpTime,
      targetBedtime: targetBedtime ?? this.targetBedtime,
    );
  }

  @override
  List<Object?> get props => [items, selectedDate, targetWakeUpTime, targetBedtime];
}
